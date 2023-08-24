import UIKit

// MARK: - MovieQuizViewController Class Protocol
protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func show(quizStep model: QuizStepViewModel)
    func show(alert model: AlertModel)
    func toggleButtons(to state: Bool)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator(is state: Bool)
}

// MARK: - MovieQuizViewController Class
final class MovieQuizViewController: UIViewController {
    
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var counerLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter?
    private var alertPresenter: AlertPresenter?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        activityIndicator.hidesWhenStopped = true
        
        alertPresenter = AlertPresenter(delegate: self)
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - IBActions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter?.didAnswer(isYes: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter?.didAnswer(isYes: false)
    }
}
// MARK: - MovieQuizViewControllerProtocol Methods

extension MovieQuizViewController: MovieQuizViewControllerProtocol {
    
    func show(quizStep model: QuizStepViewModel){
        imageView.layer.borderColor = UIColor.clear.cgColor
        counerLabel.text = model.questionNumber
        imageView.image = model.image
        textLabel.text = model.question
        
        // Включаем кнопки
        toggleButtons(to: true)
    }
    
    func show(alert model: AlertModel) {
        alertPresenter?.alert(with: model)
    }
    
    func toggleButtons(to state: Bool){
        noButton.isEnabled = state
        yesButton.isEnabled = state
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showLoadingIndicator(is state: Bool){
        if state {
            activityIndicator.startAnimating()
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

