import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        presenter.yesButtonClicked()
        
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        presenter.noButtonClicked()
        
    }
    
    
    
    @IBOutlet private weak var yesButtonClicked: UIButton!
    @IBOutlet private weak var noButtonClicked: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
            .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    //MARK: - Private function
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor=UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.text
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func buttonsEnable(isEnabled: Bool) {
        noButtonClicked.isEnabled = isEnabled
        yesButtonClicked.isEnabled = isEnabled
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false 
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true }
        
    func showNetworkError(message: String) {
            hideLoadingIndicator()
            
            let alert = UIAlertController(
                title: "Ошибка",
                message: message,
                preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Попробовать ещё раз",
                                       style: .default) { [weak self] _ in
                guard let self = self else { return }
                
                self.presenter.restartGame()
            }
            
            alert.addAction(action)
        }
    
    
}
