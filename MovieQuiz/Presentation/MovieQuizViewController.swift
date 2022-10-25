import UIKit
extension UIColor {
    static var ypGreen: UIColor {
        UIColor(named: "ypGreen" ) ?? UIColor.green
    }
    
    static var ypRed: UIColor {
        UIColor(named: "ypRed" ) ?? UIColor.red
    }
}


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
//    enum FileManagerError: Error {
//        case fileDoesntExist
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(NSHomeDirectory())
//        UserDefaults.standard.set(true, forKey: "viewDidLoad")
//
//        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        print(documentsURL)
//        let fileName = "inception.json"
//        documentsURL.appendPathComponent(fileName)
//        print(documentsURL)
//        let jsonString = try? String(contentsOf: documentsURL)
//        let data = jsonString?.data(using: .utf8)
//        guard let data = data else {
//            return
//        }
//
//        do {
//            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            let title = json?["title"]
//            let year = json?["year"]
//            let actorList = json?["actorList"] as! [Any]
//            for actor in actorList {
//                if let actor = actor as? [String: Any] {
//                    print(actor["asCharacter"])
//                }
//            }
//        } catch {
//            print("Failed to parse: \(jsonString)")
//        }
        
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        
        alertPresenter = AlertPresenter(viewController: self)
        statisticService = StatisticServiceImplementation()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    // тут мы заполняем картинку, текст и счётчик данными
    private func show(quiz step: QuizStepViewModel) {
        noButton.isEnabled = true
        yesButton.isEnabled = true
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
        
    }
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let isCorrect = !currentQuestion.correctAnswer
        self.showAnswerResult(isCorrect: isCorrect)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let isCorrect = currentQuestion.correctAnswer
        self.showAnswerResult(isCorrect: isCorrect)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            guard let statisticService = statisticService else {
                return
            }
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            print(statisticService.bestGame)
            let text = """
            Ваш результат \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
//            \(String(format: "%.2f", statisticService.totalAccuracy))%"
//            let text = correctAnswers == questionsAmount ?
//            "Поздравляем, Вы ответили на 10 из 10!" :
//            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] in
                    guard let self = self else { return }
                    //обнуляем счетчики
                    self.correctAnswers = 0
                    self.currentQuestionIndex = 0
                    // и заново показываем первый вопрос
                    self.questionFactory?.requestNextQuestion()
                })
            
            alertPresenter?.presentAlert(model: alertModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
}
