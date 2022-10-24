import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate  {
    
    
    // MARK: - Lifecycle

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService = StatisticServiceImplementation()
    
    @IBOutlet private weak var buttonNo: UIButton!
    @IBOutlet private weak var buttonYes: UIButton!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        buttonNo.isEnabled = false
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        let giveAnswer = false
        showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        buttonYes.isEnabled = false
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        let giveAnswer = true
        showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSHomeDirectory())
        print(Bundle.main.bundlePath)
        
        // MARK: - JSON
//        let fileManager = FileManager.default
//        let fileDoc = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
//        let jsonString = "inception.json"
//        guard let jsonStringUrl = fileDoc?.appendingPathComponent(jsonString) else { return }
//        guard let jsonString = try? String(contentsOf: jsonStringUrl) else { return }
//        let data = jsonString.data(using: .utf8)!
//
//        do {
//            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//
//              guard let json = json,
//                    let id = json["id"] as? String,
//                    let title = json["title"] as? String,
//                    let jsonYear = json["year"] as? String,
//                    let year = Int(jsonYear),
//                    let image = json["image"] as? String,
//                    let releaseDate = json["releaseDate"] as? String,
//                    let jsonRuntimeMins = json["runtimeMins"] as? String,
//                    let runtimeMins = Int(jsonRuntimeMins),
//                    let directors = json["directors"] as? String,
//                    let actorList = json["actorList"] as? [Any] else {
//                  return
//              }
//
//            var actors: [Actor] = []
//
//            for actor in actorList {
//                guard let actor = actor as? [String: Any],
//                      let id = actor["id"] as? String,
//                      let name = actor["name"] as? String,
//                      let asCharacter = actor["asCharacter"] as? String else {
//                    return
//                }
//                let mainActor = Actor(id: id,
//                                      image: image,
//                                      name: name,
//                                      asCharacter: asCharacter)
//                actors.append(mainActor)
//            }
//
//            let movie = Movie(id: id,
//                              title: title,
//                              year: year,
//                              image: image,
//                              releaseDate: releaseDate,
//                              runtimeMins: runtimeMins,
//                              directors: directors,
//                              actorList: actors)
//        } catch {
//            print("Failed to parse: \(jsonString)")
//        }
        
        //Создание файла
//        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        print(documentsURL)
//        let fileName = "text.swift"
//        documentsURL.appendPathComponent(fileName)
//        if !FileManager.default.fileExists(atPath: documentsURL.path) {
//            let hello = "Hello world!"
//            let data = hello.data(using: .utf8)
//            FileManager.default.createFile(atPath: documentsURL.path, contents: data)
//        }
        
        UserDefaults.standard.set(true, forKey: "viewDidLoad")
        
        alertPresenter = AlertPresenter(delegate: self)
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
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
    
    // MARK: - AlertPresenterDelegate
    
    func didShowAlert(controller: UIAlertController?) {
            guard let controller = controller else {
                return
            }
            present(controller, animated: true, completion: nil)
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
        //imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
//    private func showNextQuestionOrResults() {
//        buttonNo.isEnabled = true
//        buttonYes.isEnabled = true
//        if currentQuestionIndex == questionsAmount - 1 {
//            let text = "Ваш результат: \(correctAnswers) из \(questionsAmount)"
//            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
//            show(quiz: viewModel) // show result
//
//            imageView.layer.borderWidth = 0
//        } else {
//            currentQuestionIndex += 1
//            imageView.layer.borderWidth = 0
//            questionFactory?.requestNextQuestion()
//        }
//    }
    
    
    private func showNextQuestionOrResults() {
        buttonNo.isEnabled = true
        buttonYes.isEnabled = true

        if currentQuestionIndex == questionsAmount - 1 {
            
            if statisticService.gamesCount >= 0 {
                statisticService.gamesCount += 1
            }
            
            let record = GameRecord(correct: correctAnswers, total: questionsAmount, date: Date().dateTimeString)
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let isBestRecord = GameRecord.isBest(current: record, previous: statisticService.bestGame)

            if isBestRecord {
                statisticService.bestGame = record
            }
            
            let text = "Ваш результат: \(correctAnswers) из \(questionsAmount)\nКоличество сыграных квизов: \(statisticService.gamesCount)\nРекорд:  \(statisticService.bestGame.correct)/\(questionsAmount) \(statisticService.bestGame.date)\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy as CVarArg))%"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
            show(quiz: viewModel) // show result
            } else {
                currentQuestionIndex += 1
                imageView.layer.borderWidth = 0
                questionFactory?.requestNextQuestion()
            }

    }

    
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = "\(step.questionNumber)"
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: {
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        })
        alertPresenter?.showAlert(model: alertModel)

    }
}
