import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizControllerProtocol {
    
    // MARK: - Lifecycle
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var presenter: MovieQuizPresenter!
    
    //Определяем внешний вид статус бара в приложении
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20

        //Загружаем необходимый вид статус бара
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    //MARK: - Indicator Status Methods
    
    func showLoadingIndictor(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator(){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
 
    //MARK: - Main Methods
    
    func isButtonsBlocked(state: Bool) {
        yesButton.isEnabled = !state
        noButton.isEnabled = !state
    }
    
    func show(quiz step: QuizStepViewModel) {
        UIView.transition(with: imageView,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: {
            self.imageView.image = step.image
            self.imageView.layer.borderWidth = 0
        },
                          completion: { _ in
            self.textLabel.text = step.question
            self.counterLabel.text = step.questionNumber
            self.isButtonsBlocked(state: false)
        })
    }
    
    // MARK: - Actions Methods
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
}
