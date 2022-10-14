import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Outlets and Actions

    @IBOutlet private weak var poster: UIImageView!
    @IBOutlet private weak var questionText: UILabel!
    @IBOutlet private weak var questionCounter: UILabel!
    @IBOutlet private var answerButtons: [UIButton]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: checkAnswerCorrectness(for: true))
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: checkAnswerCorrectness(for: false))
    }

    // MARK: - Vars

    private var currentQuestionIndex: Int = 0
    private var correctAnswersCount: Int = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var alert: AlertPresenter?
    private var statisticService: StatisticService?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        poster.layer.masksToBounds = true
        
        alert = AlertPresenter(controller: self)
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        
        showLoadingIndicator()
        
        statisticService = StatisticServiceImplementation()
    }
    
    // MARK: - Overridden functions
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private methods
    
    private func toggleButtonsEnableProperty(to value: Bool) {
        answerButtons.forEach { $0.isEnabled = value }
    }

    private func checkAnswerCorrectness(for chosenAnswer: Bool) -> Bool {
        guard let currentQuestion = currentQuestion else { return false }
        
        return chosenAnswer == currentQuestion.correctAnswer
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let content = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") { [weak self] in
                guard let self = self else { return }
                
                self.questionFactory?.loadData()
            }
        
        alert?.showAlert(with: content)
    }

    private func show(quiz step: QuizStepViewModel) {
        poster.image = step.image
        questionText.text = step.question
        questionCounter.text = step.questionNumber
        
        toggleButtonsEnableProperty(to: true)
    }

    private func show(quiz result: QuizResultsViewModel) {
        let content = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: self.restartQuiz)
        
        alert?.showAlert(with: content)
    }

    private func showAnswerResult(isCorrect: Bool) {
        toggleButtonsEnableProperty(to: false)
        
        if isCorrect {
            correctAnswersCount += 1
        }

        poster.layer.borderWidth = 8
        poster.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            self.poster.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            guard let statisticService = statisticService else { return }
            
            statisticService.store(correct: correctAnswersCount, total: questionsAmount)
            
            let text = """
                Ваш результат: \(correctAnswersCount) из \(questionsAmount)\n
                Количество сыгранных квизов: \(statisticService.gamesCount)\n
                Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))\n
                Cредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Cыграть еще раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func restartQuiz() {
        currentQuestionIndex = 0
        correctAnswersCount = 0

        questionFactory?.requestNextQuestion()
    }
}

// MARK: - QuestionFactoryDelegate

extension MovieQuizViewController {
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
        
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        restartQuiz()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}
