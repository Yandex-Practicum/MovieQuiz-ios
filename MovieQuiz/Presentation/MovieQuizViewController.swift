import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    private var presenter: MovieQuizPresenterProtocol!
    private var alertPresenter: AlertPresenterProtocol!
    private var isButtonsLocked = true
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noButton.layer.cornerRadius = 15.0
        yesButton.layer.cornerRadius = 15.0
        imageView.layer.cornerRadius = 15.0
        
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)!
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)!
        alertPresenter = AlertPresenterImpl(viewController: self)
        presenter = MovieQuizPresenter(viewController: self, alertPresenter: alertPresenter)
        alertPresenter = AlertPresenterImpl(viewController: self)
        imageView.layer.cornerRadius = 20
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
        setButtonsLocked(false)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
        setButtonsLocked(false)
    }
    
    
    // MARK: -  functions
    
    func setButtonsLocked(_ isLocked: Bool) {
        isButtonsLocked = isLocked
        yesButton.isEnabled = isLocked
        noButton.isEnabled = isLocked
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        presenter.showQuizResultsAlert()
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(alertModel : AlertModel) {
        hideLoadingIndicator()
        alertPresenter?.show(alertModel: alertModel)
    }
}

