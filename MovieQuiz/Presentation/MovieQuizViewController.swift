import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }

    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService = StatisticServiceImplementation()
    private var resultAlertPresenter: ResultAlertPresenterProtocol?
    private var currentQuestionIndex: Int = 0
    private var rightAnswerCount: Int = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }

    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }

    private func showStep(quize step: QuizStepViewModel) {
        noButton.isUserInteractionEnabled = true
        yesButton.isUserInteractionEnabled = true
        movieImageView.image = step.image
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    private func createStepModel(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage.checkmark,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }

    private func showAnswerResult(isCorrect: Bool) {
        noButton.isUserInteractionEnabled = false
        yesButton.isUserInteractionEnabled = false
        movieImageView.layer.borderWidth = 8
        movieImageView.layer.borderColor = UIColor(named: isCorrect ? "ypGreen" : "ypRed")!.cgColor
        if isCorrect {
            rightAnswerCount += 1
        }
    }
    private func getResultMessage() -> String {
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.yyyy hh:mm"
        let result: String = "Ваш результат: \(rightAnswerCount)/\(questionsAmount)."
        let quize: String = "Количество сыгранных квизов: \(statisticService.gamesCount)."
        let record: String = "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))"
        let statistic: String = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        return result + "\n" + quize + "\n" + record + "\n" + statistic
    }

    private func startNewQuiz() {
        self.currentQuestionIndex = 0
        self.rightAnswerCount = 0
        self.questionFactory?.requestNextQuestion()
    }
    private func loadData() {
        self.questionFactory?.loadData()
    }
    private func requestQuestion() {
        self.questionFactory?.requestNextQuestion()
    }
    private func showNextQuestionOrResults() {
        movieImageView.layer.borderWidth = 0
        movieImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.0).cgColor
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: rightAnswerCount, total: questionsAmount)
            resultAlertPresenter = ResultAlertPresenter(
                title: "Этот раунд окончен",
                text: getResultMessage(),
                buttonText: "Сыграть еще раз",
                controller: self
            )
            resultAlertPresenter?.showAlert(callback: startNewQuiz)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }

    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.showNextQuestionOrResults()
        }
    }

    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.showNextQuestionOrResults()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        yesButton.layer.cornerRadius = 15
        noButton.layer.cornerRadius = 15
        movieImageView.layer.masksToBounds = true
        movieImageView.layer.cornerRadius = 20
        let moviesLoader = MoviesLoader()
        questionFactory = QuestionFactory(moviesLoader: moviesLoader, delegate: self)
        loadData()
        showLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            resultAlertPresenter = ResultAlertPresenter(
                title: "Что-то пошло не так",
                text: "Не удалось загрузить вопрос",
                buttonText: "Попробовать еще раз",
                controller: self
            )
            resultAlertPresenter?.showAlert(callback: requestQuestion)
            return
        }
        currentQuestion = question
        let viewModel = createStepModel(model: question)
        hideLoadingIndicator()
        DispatchQueue.main.async { [weak self] in
            self?.showStep(quize: viewModel)
        }
    }
    func didRequestNextQuestion() {
        showLoadingIndicator()
    }

    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        hideLoadingIndicator()
        resultAlertPresenter = ResultAlertPresenter(
            title: "Что-то пошло не так",
            text: error.localizedDescription,
            buttonText: "Попробовать еще раз",
            controller: self
        )
        resultAlertPresenter?.showAlert(callback: loadData)
    }
}
