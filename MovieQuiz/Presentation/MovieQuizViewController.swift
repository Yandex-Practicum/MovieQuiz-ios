import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var questionAlert: AlertProtocol?
    private var statisticService: StatisticService?
    
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var questionNumber: Int = 1
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        
        questionFactory = QuestionFactory(delegate: self)
        questionAlert = AlertPresenter(controller: self)
        statisticService = StatisticServiceImplementation()
        
        questionFactory?.requestNextQuestion()
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
    
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        checkAnswer(buttonValue: false)
        buttonState(isEnable: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        checkAnswer(buttonValue: true)
        buttonState(isEnable: false)
    }
    
    private func buttonState(isEnable state: Bool){
        noButton.isEnabled = state
        yesButton.isEnabled = state
    }
    
    private func show(quiz step: QuizStepViewModel) {
        
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        buttonState(isEnable: true)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let viewModel: QuizStepViewModel = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(questionNumber)/\(questionsAmount)"
            )
        
        return viewModel
    }
    
    private func checkAnswer(buttonValue: Bool) {
        guard let currentQuestion = currentQuestion else {return}
        
        showAnswerResult(isCorrect: (buttonValue == currentQuestion.correctAnswer))
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        }
        else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestion()
            }
    }
    
    
    // Выводим вопрос на экран
    private func showNextQuestion(){
        
        if !checkQuestion() {
            showResults()
        }
        else {
            questionNumber += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showResults(){
        statisticService?.store(correct: correctAnswers, total: questionNumber)
        
        let viewModel = AlertModel(
            title: "Этот раунд окончен",
            message: createResultMessage(),
            buttonText: "Сыграть ещё раз",
            action: { [weak self]  in
                guard let self = self else {return}
                self.questionNumber = 1
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            })
        
        questionAlert?.showAlert(alertModel: viewModel)
    }
    
    private func createResultMessage() -> String {
        
        guard let statisticService = statisticService else {return ""}
        guard let bestGame = statisticService.bestGame else {return ""}
        
        let currentResult = "Ваш результат: \(correctAnswers) из \(questionsAmount)"
        
        let totalGameNumber = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let bestResult = "Рекорд:\(bestGame.correct)\\\(bestGame.total)" + " (\(bestGame.date.dateTimeString))"
        let averageAccuracy = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMessage = "\(currentResult) \n\(totalGameNumber) \n\(bestResult) \n\(averageAccuracy)"
        
        return resultMessage
    }
    
    
    private func checkQuestion() -> Bool {
        if questionNumber + 1 > questionsAmount {
            return false
        }
        return true
    }
    
}
