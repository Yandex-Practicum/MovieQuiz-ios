import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private weak var noAnswerButton: UIButton!
    @IBOutlet private weak var yesAnswerButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private var presenter: MovieQuizPresenter!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
    }

    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }

    // MARK: - Buttons interactions
    func disableButtons() {
        yesAnswerButton.isUserInteractionEnabled = false
        noAnswerButton.isUserInteractionEnabled = false
    }

    func enableButtons() {
        yesAnswerButton.isUserInteractionEnabled = true
        noAnswerButton.isUserInteractionEnabled = true
    }

    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }

    // MARK: - Loading indicator
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = true
        }
    }

    // MARK: - Setup Method
    private func setupViewModel() {
        presenter.questionFactory?.loadData()
    }

    func updateImageBorder() {
        imageView.layer.borderColor = UIColor.clear.cgColor
    }

    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    // MARK: - View
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()

        let alert = ResultAlertPresenter(
            title: result.title,
            message: message,
            controller: self,
            actionHandler: { [weak self] _ in
                guard let self = self else { return }
            })
        DispatchQueue.main.async {
            alert.showResultAlert()
        }
    }

    func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.image = step.image
    }

    // MARK: - Error's Methods
    func showErrorEmptyJson(message: String) {
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

    func showNetworkError(message: String) {
        hideLoadingIndicator()

        let alert = ResultAlertPresenter(
            title: "Ошибка сети",
            message: message,
            controller: self,
            actionHandler: { [weak self] _ in
                guard let self = self else { return }
                self.presenter.restartGame()
            })
        self.presenter.restartGame()
        self.presenter.correctAnswers = 0
        DispatchQueue.main.async {
            alert.showErrorAlert()
        }
    }

    func showImageError(message: String) {
        let alert = ResultAlertPresenter(
            title: "Упс! Не можем загрузить картинку :(",
            message: "Проверьте подклчюение к интернету или попробуйте позднее",
            controller: self,
            actionHandler: {  _ in
                self.presenter.questionFactory?.requestNextQuestion()
            })
        DispatchQueue.main.async {
            alert.showErrorAlert()
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
