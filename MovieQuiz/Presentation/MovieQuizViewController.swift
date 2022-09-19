import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private weak var noAnswerButton: UIButton!
    @IBOutlet private weak var yesAnswerButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private var presenter = MovieQuizPresenter()

    private var questionFactory: QuestionFactoryProtocol?

    private var counterCorrectAnswers: Int = 0

    private var statisticService: StatisticService = StatisticServiceImpl()
    private var moviesLoader = MoviesLoader()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
        questionFactory = QuestionFactory(
            moviesLoder: moviesLoader,
            delegate: self)

        presenter.viewController = self
        questionFactory?.loadData()
    }

    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }

    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }

    func didLoadDataFromServer() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = true
            self?.questionFactory?.requestNextQuestion()
        }
    }

    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
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

    // MARK: - Private Functions
    func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.image = step.image
    }

    private func setupViewModel() {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
        questionFactory = QuestionFactory(
            moviesLoder: moviesLoader,
            delegate: self)

        questionFactory?.loadData()
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
        hideLoadingIndicator()

        let alert = ResultAlertPresenter(
            title: "Ошибка сети",
            message: message,
            controller: self,
            actionHandler: { [weak self] _ in
                guard let self = self else { return }
                self.questionFactory?.requestNextQuestion()
            })
        self.presenter.restartGame()
        self.presenter.correctAnswers = 0
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

//    private func showNextQuestionOrResults() {
//        yesAnswerButton.isEnabled = true
//        noAnswerButton.isEnabled = true
//        if presenter.isLastQuestion() {
//            numberOfQuizGames += 1
//            correctAnswers += counterCorrectAnswers
//            getResultQuiz()
//        } else {
//            presenter.switchToNextQuestion()
//            questionFactory?.requestNextQuestion()
//        }
//    }

    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            counterCorrectAnswers += 1
        }

//        yesAnswerButton.isEnabled = false
//        noAnswerButton.isEnabled = false

        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
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
