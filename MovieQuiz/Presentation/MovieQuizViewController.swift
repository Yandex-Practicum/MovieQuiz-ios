import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showFinalAlert()
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate, MovieQuizViewControllerProtocol {

    // MARK: - Lifecycle
        
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    private var alertModel: AlertModel?
    private var alertPresenter: AlertPresenterProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
// MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
    }
    
    // MARK: Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - AlertPresenterDelegate
    
    func alertPresent(alert: UIAlertController?) {
        guard let alert = alert else {
            return
        }
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Private functions
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] _ in
                guard let self = self else { return }
                self.presenter.restartGame()
            }
        
        alertPresenter = AlertPresenter(alertDelegate: self)
        alertPresenter?.makeAlertController(alertModel: alert)
    }
    
    func showFinalAlert() {
        
        let message = presenter.makeResultMessage()
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть ещё раз") { [weak self] _ in
                guard let self = self else { return }
                self.presenter.restartGame()
            }
        
        alertPresenter = AlertPresenter(alertDelegate: self)
        alertPresenter?.makeAlertController(alertModel: alertModel)
        
        
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.image = step.image
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen?.cgColor : UIColor.ypRed?.cgColor
    }
}
