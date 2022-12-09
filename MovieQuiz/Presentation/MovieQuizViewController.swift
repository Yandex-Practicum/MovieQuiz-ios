import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    //MARK: - Lifecycle
    
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol? = nil
    
    private var alertPresenter: AlertPresenterProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(alertController: self)
       /*
        print(NSHomeDirectory())
        UserDefaults.standard.set(true, forKey: "viewDidLoad")
        print(Bundle.main.bundlePath)
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //print(documentsURL)
        
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "text.swift"
        documentsURL.appendPathComponent(fileName)
        if !FileManager.default.fileExists(atPath: documentsURL.path) {
            let hello = "Hello world!"
            let data = hello.data(using: .utf8)
            FileManager.default.createFile(atPath: documentsURL.path, contents: data)
        }
        try? FileManager.default.removeItem(atPath: documentsURL.path)
        */
        //let jsonString = "inception.json"
        var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        documentDirectory.appendPathComponent("inception.json")
        let jsonString = try? String(contentsOf: documentDirectory)
        let data = jsonString?.data(using: .utf8)!
        
        //class func jsonObject(with data: Data, options opt: JSONSerialization.ReadingOptions = []) throws -> Any
        struct Actor {
            let id: String
            let image: String
            let name: String
            let asCharacter: String
        }
        struct Movie {
            let id: String
            let title: String
            let year: Int
            let image: String
            let releaseDate: String
            let runtimeMins: Int
            let directors: String
            let actorList: [Actor]
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]

              guard let json = json,
                    let id = json["id"] as? String,
                    let title = json["title"] as? String,
                    let jsonYear = json["year"] as? String,
                    let year = Int(jsonYear),
                    let image = json["image"] as? String,
                    let releaseDate = json["releaseDate"] as? String,
                    let jsonRuntimeMins = json["runtimeMins"] as? String,
                    let runtimeMins = Int(jsonRuntimeMins),
                    let directors = json["directors"] as? String,
                    let actorList = json["actorList"] as? [Any] else {
                return
            }

            var actors: [Actor] = []

            for actor in actorList {
                guard let actor = actor as? [String: Any],
                        let id = actor["id"] as? String,
                        let image = actor["image"] as? String,
                        let name = actor["name"] as? String,
                        let asCharacter = actor["asCharacter"] as? String else {
                    return
                }
                let mainActor = Actor(id: id,
                                        image: image,
                                        name: name,
                                        asCharacter: asCharacter)
                actors.append(mainActor)
            }
            let movie = Movie(id: id,
                                title: title,
                                year: year,
                                image: image,
                                releaseDate: releaseDate,
                                runtimeMins: runtimeMins,
                                directors: directors,
                                actorList: actors)
        } catch {
            print("Failed to parse: \(jsonString)")
        }
        
    }
    // MARK: - QuestionFactoryDelegate
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    // MARK: - Private functions
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        noButton.isEnabled = true
        yesButton.isEnabled = true
        
        if currentQuestionIndex == questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ?
                    "Поздравляем, Вы ответили на 10 из 10!" :
                    "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз") {
                    self.currentQuestionIndex = 0
                    self.correctAnswers = 0
                    self.questionFactory?.requestNextQuestion()
                }
            alertPresenter?.showAlert(result: alertModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
}
