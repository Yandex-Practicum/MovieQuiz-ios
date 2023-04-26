import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var questionAlert: AlertProtocol?
    private var statisticService: StatisticService?
    private var moviesLoader: MoviesLoading = MoviesLoader()
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var questionNumber: Int = 1
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self, moviesLoader: moviesLoader)
        questionAlert = AlertPresenter(controller: self)
        statisticService = StatisticServiceImplementation()
        showLoadingIndicator()
        questionFactory?.loadData()
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

    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }

    // MARK: - Работа с кнопками
    @IBAction private func noButtonClicked(_ sender: Any) {
        checkAnswer(buttonValue: false)
        buttonState(isEnable: false)
    }

    @IBAction private func yesButtonClicked(_ sender: Any) {
        checkAnswer(buttonValue: true)
        buttonState(isEnable: false)
    }

    private func buttonState(isEnable state: Bool) {
        noButton.isEnabled = state
        yesButton.isEnabled = state
    }

    // MARK: - Логика индикатора загрузки
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    // MARK: - Вывод сообщения пользователю
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor

        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber

        buttonState(isEnable: true)
    }

    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8

        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestion()
        }
    }

    private func showResults() {
        statisticService?.store(correct: correctAnswers, total: questionNumber)

        let viewModel = AlertModel(
            title: "Этот раунд окончен",
            message: createResultMessage(),
            buttonText: "Сыграть ещё раз",
            action: { [weak self]  in
                guard let self = self else {return}
                self.questionNumber = 1
                self.correctAnswers = 0
                self.questionFactory?.loadData()
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

    func showNetworkError(message: String) {
        hideLoadingIndicator()

        let viewModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            action: { [weak self]  in
                guard let self = self else {return}
                self.questionFactory?.loadData()
            }
        )

        questionAlert?.showAlert(alertModel: viewModel)
    }

    // MARK: - Работа с вопросами
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let viewModel = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(questionNumber)/\(questionsAmount)"
            )

        return viewModel
    }

    private func checkAnswer(buttonValue: Bool) {
        guard let currentQuestion = currentQuestion else {return}

        showAnswerResult(isCorrect: (buttonValue == currentQuestion.correctAnswer))
    }

    private func showNextQuestion() {
        if !checkQuestion() {
            showResults()
        } else {
            questionNumber += 1
            questionFactory?.requestNextQuestion()
        }
    }

    private func checkQuestion() -> Bool {
        if questionNumber + 1 > questionsAmount {
            return false
        }
        return true
    }
}
