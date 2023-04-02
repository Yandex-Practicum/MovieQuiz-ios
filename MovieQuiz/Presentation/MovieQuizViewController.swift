import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService?
    private var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        
        questionFactory = QuestionFactory(delegate: self)
        
        questionFactory?.requestNextQuestion()
        
        statisticService = StatisticServiceImplementation(userDefaults: UserDefaults(),
                                                          decoder: JSONDecoder(),
                                                          encoder: JSONEncoder())
        
        alertPresenter = AlertPresenter(delegate: self)
        
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
    
        
    // MARK: - Private Functions
        
    private func show(quiz step: QuizStepViewModel) { 
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
        
    private func show(quiz model: AlertModel) {
        alertPresenter?.showAlert(model: model)
    }
        
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
        
    private func showAnswerResult(isCorrect: Bool) {
        
        imageView.layer.masksToBounds = true // разрешение на рамку
        imageView.layer.borderWidth = 8 // толщина
        imageView.layer.cornerRadius = 20 // радиус скругления углов
        imageView.layer.borderColor = UIColor.white.cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        if isCorrect == true {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor // верно - зеленая рамка
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor // неверно - красная рамка
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        
            imageView.layer.borderWidth = 0
            noButton.isEnabled = true
            yesButton.isEnabled = true
        
        if currentQuestionIndex == questionsAmount - 1 {
            showFinalResults()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()

            noButton.isEnabled = true
            yesButton.isEnabled = true
        }
    }
        
    private func showFinalResults() {
        
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        
        guard let statisticService = statisticService else {
            return
        }
        guard let bestGame = statisticService.bestGame else {
            return
        }
        
        let text =
        """
        Ваш результат: \(correctAnswers)/10
        Количество сыгранных квизов: \(statisticService.gamesCount)
        Рекорд: \(bestGame.correct)/10 (\(bestGame.date.dateTimeString))
        Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
        
        let alertModel = AlertModel(title: "Этот раунд окончен!",
                                    message: text,
                                    buttonText: "Сыграть еще раз") { [ weak self ] in
                                            self?.currentQuestionIndex = 0
                                            self?.correctAnswers = 0
                                            self?.questionFactory?.requestNextQuestion()
            }
            self.alertPresenter?.showAlert(model: alertModel)
        }
        
    // MARK: - Actions
        
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let userAnswer = true
        guard let currentQuestion = currentQuestion else {
            return
        }
            
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
        
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let userAnswer = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
}
