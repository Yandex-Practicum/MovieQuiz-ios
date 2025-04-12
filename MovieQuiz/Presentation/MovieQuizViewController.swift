import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    private var presenter: MovieQuizPresenter!
    private final var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let transfrom = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
        activityIndicator.transform = transfrom
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(viewController: self)
        setupImageBorder(isHidden: true)
        activityIndicator.startAnimating()
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    // MARK: - IB Actions
    @IBAction private func noButtonClicked() {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked() {
        presenter.yesButtonClicked()
    }
    
    func show(quiz step: QuizStepViewModel) {
        setupImageBorder(isHidden: true)
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: AlertModel) {
        alertPresenter?.showResult(model: result)
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        show(quiz: AlertModel(title: "Ошибка!",
                              message: message,
                              buttonText: "Попробовать еще раз",
                              completion: { [weak self] _ in
            guard let self else { return }
            presenter.restartGame()
        }))
    }
    
    func highlightImageBorder(isCorrectAnswer isCorrect: Bool) {
        blockButton(isBlocked: true)
        setupImageBorder(isHidden: false)
        imageView.layer.borderColor =  isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func blockButton(isBlocked: Bool) {
        noButton.isEnabled = isBlocked ? false : true
        yesButton.isEnabled = isBlocked ? false : true
    }
    
    func setupImageBorder(isHidden: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = isHidden ? 0 : 8
        imageView.layer.cornerRadius = 20
    }
    
    func showLoadingIndicator() {
        activityIndicator.color = .black
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
