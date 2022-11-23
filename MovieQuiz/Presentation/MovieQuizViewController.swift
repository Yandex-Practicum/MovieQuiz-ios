import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService = StatisticServiceImplementation()
    
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        updateStatusButton(isActive: false)
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: false == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        updateStatusButton(isActive: false)
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: true == currentQuestion.correctAnswer )
    }
    
    // MARK: - Private Functions
    private func show(quiz step: QuizStepViewModel) {
        
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] _ in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.showAlert(alertModel: alertModel)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage() ,
                          question: model.text ,
                          questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        correctAnswers += isCorrect ?  1 : 0
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        
        imageView.layer.borderWidth = 0
        currentQuestionIndex += 1
        
        if currentQuestionIndex == questionsAmount {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let alertText = "Ваш результат: \(correctAnswers)/\(questionsAmount) \n" +
            "Количество сыгранных квизов: \(statisticService.gamesCount)" +
            "\n Рекорд: \(statisticService.bestGame.toString())" +
            "\n Средняя точность:  \(String(format: "%.2f", statisticService.totalAccuracy))%"
            show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!" , text: alertText, buttonText: "Сыграть еще раз"))
            questionFactory?.shuffleQuesions()
        } else {
            questionFactory?.requestNextQuestion()
        }
        updateStatusButton(isActive: true)
    }
    
    private func updateStatusButton(isActive: Bool) {
        yesButton.isEnabled = isActive
        noButton.isEnabled = isActive
    }
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.shuffleQuesions()
        questionFactory?.requestNextQuestion()

        alertPresenter = AlertPresenter(viewController: self)
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
}
