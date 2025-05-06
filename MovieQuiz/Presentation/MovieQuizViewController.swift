import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
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
    
    
    // MARK: - Переменные и константы
    
    private var currentQuestionIndex = 0
        private var correctAnswers = 0
        private var questionFactory: QuestionFactoryProtocol?
        private var currentQuestion: QuizQuestion?
        private var alertPresenter: AlertPresenter?
        private var statisticService: StatisticService?
        private let questionsAmount = 10
    
    // MARK: - UIOutlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
            super.viewDidLoad()
            statisticService = StatisticServiceImplementation()
            questionFactory = QuestionFactory()
            questionFactory?.delegate = self
            questionFactory?.requestNextQuestion()
            alertPresenter = AlertPresenter(viewController: self)
        }
    
    // MARK: - Button Yes
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let checkAnswer = true
        guard let currentQuestion = currentQuestion else {
            return
        }
        if checkAnswer == currentQuestion.correctAnswer {
            correctAnswers += 1
        }
        showAnswerResult(isCorrect: checkAnswer == currentQuestion.correctAnswer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    // MARK: - Button No
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let checkAnswer = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        if checkAnswer == currentQuestion.correctAnswer {
            correctAnswers += 1
        }
        showAnswerResult(isCorrect: checkAnswer == currentQuestion.correctAnswer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    // MARK: - Method "Convert"
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    // MARK: - Method "resetImageViewBorder"
    
    private func resetImageViewBorder() {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    // MARK: - Method "Show"
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        resetImageViewBorder()
    }
    
    // MARK: - Method "ShowAnswerResult"
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
    }
    
    // MARK: - Method "ShowNextQuestionOrResults"
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex >= questionsAmount - 1 {
            guard let statisticService = statisticService else { return }
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let gamesPlayed = statisticService.gamesCount
            let averageAccuracy = statisticService.totalAccuracy
            let bestGame = statisticService.bestGame
            let bestScore = "\(bestGame.correct)/\(bestGame.total)"
            let bestDate = bestGame.date.dateTimeString
            
            let message = """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(gamesPlayed)
            Рекорд: \(bestScore) (\(bestDate))
            Средняя точность: \(String(format: "%.2f%%", averageAccuracy))
            """
            
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: message,
                buttonText: "Сыграть ещё раз"
            ) { [weak self] in
                self?.restartQuiz()
            }
            
            alertPresenter?.showAlert(with: alertModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }

    
    // MARK: - Method "RestartQuiz"
    
    private func restartQuiz() {
            currentQuestionIndex = 0
            correctAnswers = 0
            questionFactory?.requestNextQuestion()
        }
}
