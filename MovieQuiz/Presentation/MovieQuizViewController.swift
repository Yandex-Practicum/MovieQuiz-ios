import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private weak var noAnswerButton: UIButton!
    @IBOutlet private weak var yesAnswerButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private let presenter = MovieQuizPresenter()

    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?

    private var counterCorrectAnswers: Int = 0
    private var numberOfQuizGames: Int = 0
    private var recordCorrectAnswers: Int = 0
    private var recordDate = Date()
    private var averageAccuracy: Double = 0.0
    private var correctAnswers: Int = 0

    private var statisticService: StatisticService = StatisticServiceImpl()
    private var moviesLoader = MoviesLoader()
    private var gameCount: Int = 0


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
        questionFactory = QuestionFactory(
            moviesLoder: moviesLoader,
            delegate: self)

        questionFactory?.loadData()
    }

    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            self.questionFactory?.requestNextQuestion()
            return
        }

        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }

    func didLoadDataFromServer() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = true
            self?.questionFactory?.requestNextQuestion()
        }
    }

    func didReceiveEmptyJson(errorMessage errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showErrorEmptyJson(message: errorMessage)
        }
    }

    func didFailToLoadData(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.showNetworkError(message: error.localizedDescription)
        }
    }

    func didFailToLoadImage(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.showImageError(message: error.localizedDescription)
        }
    }

    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }

        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }

        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }

    // MARK: - Private Functions
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.image = step.image
    }

    private func restart() {
        counterCorrectAnswers = 0
        presenter.resetQuestionIndex()
        questionFactory?.loadData()
    }

    private func setupViewModel() {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
        questionFactory = QuestionFactory(
            moviesLoder: moviesLoader,
            delegate: self)

        questionFactory?.loadData()
    }

    private func showLoadingIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }

    private func showErrorEmptyJson(message: String) {
        let alert = ResultAlertPresenter(
            title: "Упс! Кажется мы не получили данные о фильме",
            message: message,
            controller: self,
            actionHandler: { _ in }
        )
        DispatchQueue.main.async {
            alert.showErrorAlert()
        }
    }

    private func showNetworkError(message: String) {
        let alert = ResultAlertPresenter(
            title: "Что-то пошло не так",
            message: message,
            controller: self,
            actionHandler: { [weak self] _ in
                guard let self = self else { return }
                self.questionFactory?.requestNextQuestion()
            })
        self.presenter.resetQuestionIndex()
        self.correctAnswers = 0
        DispatchQueue.main.async {
            alert.showErrorAlert()
        }
    }

    private func showImageError(message: String) {
        let alert = ResultAlertPresenter(
            title: "Упс! Не можем загрузить картинку :(",
            message: "Проверьте подклчюение к интернету или попробуйте позднее",
            controller: self,
            actionHandler: { [weak self] _ in
                guard let self = self else { return }
                self.questionFactory?.requestNextQuestion()
            })
        DispatchQueue.main.async {
            alert.showErrorAlert()
        }
    }

    private func show(quiz result: QuizResultsViewModel) {
        statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)


        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(presenter.questionsAmount)"

        let alert = ResultAlertPresenter(
            title: result.title,
            message: result.text,
            controller: self,
            actionHandler: { [weak self] _ in
                guard let self = self else { return }
                self.questionFactory?.requestNextQuestion()
            })

//        let action = UIAlertAction(
//            title: result.buttonText,
//            style: .default
//        ) { [weak self] _ in
//            guard let self = self else { return }
//            self.presenter.resetQuestionIndex()
//        }
        DispatchQueue.main.async {
            alert.showResultAlert()
        }
    }

    private func showNextQuestionOrResults() {
        yesAnswerButton.isEnabled = true
        noAnswerButton.isEnabled = true

        if presenter.isLastQuestion() {
            numberOfQuizGames += 1
            correctAnswers += counterCorrectAnswers
            getResultQuiz()
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }

    private func getResultQuiz() {
        var title = counterCorrectAnswers == presenter.questionsAmount ? "Вы победили!" : "Этот раунд окончен!"

        averageAccuracy = Double(correctAnswers * 100) / Double(presenter.questionsAmount * numberOfQuizGames)
        statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
        let resultQuiz = ResultAlertPresenter(
            title: title,
            message: """
                Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
                Количество сыгранных квизов: \(statisticService.gamesCount)
                Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) \(statisticService.bestGame.date.dateTimeString)
                Средняя точность: \(String(format: "%.2f", averageAccuracy))%
            """,
            controller: self,
            actionHandler: { [weak self] _ in
                guard let self = self else { return }
                self.restart()
            }
        )
        resultQuiz.showResultAlert()
    }

    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            counterCorrectAnswers += 1
        }

        yesAnswerButton.isEnabled = false
        noAnswerButton.isEnabled = false
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            self.showNextQuestionOrResults()
        }
    }



    // MARK: - Status bar and orientations settings
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
}
