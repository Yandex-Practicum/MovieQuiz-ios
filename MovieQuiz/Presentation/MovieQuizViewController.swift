import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol? = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter? = AlertPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
        questionFactory?.requestNextQuestion()
        
        if let jsonString = getJSONString() {
            guard let movie = getMovie(from: jsonString) else { return }
            print(movie.title)
        }
    }
    
    private func getMovie(from jsonString: String) -> Movie? {
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        var movie: Movie? = nil
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            guard let json = json,
                  let id = json["id"] as? String,
                  let title = json["title"] as? String,
                  let year = json["year"] as? String,
                  let image = json["image"] as? String,
                  let releaseDate = json["releaseDate"] as? String,
                  let runtimeMins = json["runtimeMins"] as? String,
                  let directors = json["directors"] as? String,
                  let actorList = json["actorList"] as? [Any]
            else { return nil }
            
            var actors: [Actor] = []
            for actor in actorList {
                if let actor = actor as? [String: Any] {
                    guard let id = actor["id"] as? String,
                          let image = actor["image"] as? String,
                          let name = actor["name"] as? String,
                          let asCharacter = actor["asCharacter"] as? String
                    else { return nil }
                    
                    actors.append(Actor(id: id, image: image, name: name, asCharacter: asCharacter))
                }
            }
            
            movie = Movie(id: id,
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
        
        return movie
    }
    
    private func getJSONString() -> String? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).first else { return nil }
        let fileName = "inception.json"
        let fileURL = documentsURL.appendingPathComponent(fileName)
        return try? String(contentsOf: fileURL)
    }
    
    private func setDelegates() {
        questionFactory?.delegate = self
        alertPresenter?.delegate = self
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let correctAnswer = currentQuestion.correctAnswer
        showAnswerResult(isCorrect: correctAnswer == true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let correctAnswer = currentQuestion.correctAnswer
        showAnswerResult(isCorrect: correctAnswer == false)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                          question: model.text,
                          questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }

    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect { correctAnswers += 1 }
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen?.cgColor : UIColor.ypRed?.cgColor
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        
        if currentQuestionIndex == questionsAmount - 1 {
            let text = "Ваш результат: \(correctAnswers) из 10"
            
            let alertModel = AlertModel(title: "Этот раунд окончен!",
                                        message: text,
                                        buttonText: "Сыграть ещё раз",
                                        completion: { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            })
            
            alertPresenter?.show(result: alertModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
}

// MARK: - QuestionFactoryDelegate
extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}

// MARK: - AlertPresenterDelegate
extension MovieQuizViewController: AlertPresenterDelegate {
    func didReceiveAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
}
