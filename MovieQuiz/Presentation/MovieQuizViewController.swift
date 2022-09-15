import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private weak var noAnswerButton: UIButton!
    @IBOutlet private weak var yesAnswerButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var questionsAmount: Int = 10

    private var currentQuestionIndex: Int = 0
    private var counterCorrectAnswers: Int = 0
    private var numberOfQuizGames: Int = 0
    private var recordCorrectAnswers: Int = 0
    private var recordDate = Date()
    private var averageAccuracy: Double = 0.0
    private var allCorrectAnswers: Int = 0

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
        let viewModel = convert(model: question)
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
        currentQuestionIndex = 0
        questionFactory?.loadData()
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? .remove,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
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
        let alert = ResultAlertPresenter(
            title: result.title,
            message: result.text,
            controller: self,
            actionHandler: { [weak self] _ in
                guard let self = self else { return }
                self.questionFactory?.requestNextQuestion()
            })
        DispatchQueue.main.async {
            alert.showResultAlert()
        }
    }

    private func showNextQuestionOrResults() {
        yesAnswerButton.isEnabled = true
        noAnswerButton.isEnabled = true

        if currentQuestionIndex == questionsAmount - 1 {
            numberOfQuizGames += 1
            allCorrectAnswers += counterCorrectAnswers
            getResultQuiz()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
//            setupViewModel()
        }
    }

    private func getResultQuiz() {
        var title = "Игра окончена!"
        if counterCorrectAnswers >= recordCorrectAnswers {
            title = "Поздравляем! Новый рекорд!"
            recordCorrectAnswers = counterCorrectAnswers
        }

        if counterCorrectAnswers == numberOfQuizGames {
            title = "Поздравляем! Это лучший результат"
        }
        averageAccuracy = Double(allCorrectAnswers * 100) / Double(questionsAmount * numberOfQuizGames)
        statisticService.store(correct: allCorrectAnswers, total: questionsAmount)
        let resultQuiz = ResultAlertPresenter(
            title: title,
            message: """
                Ваш результат: \(allCorrectAnswers)/\(questionsAmount)
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

    private func showAnswerResult(isCorrect: Bool) {
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
