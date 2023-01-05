import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    //MARK: - Lifecycle
    
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
  
    private var alertPresenter: AlertPresenterProtocol? = nil//
   
    private var presenter: MovieQuizPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
 
        alertPresenter = AlertPresenter(alertController: self)
      
        presenter = MovieQuizPresenter(viewController: self)
        
    }
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - Private functions
    
    func show(quiz step: QuizStepViewModel) {
        
        imageView.layer.borderColor = UIColor.clear.cgColor
        noButton.isEnabled = true
        yesButton.isEnabled = true
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        self.presenter.alertPresenter = self.alertPresenter
    }
        
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: { [weak self]  in
                guard let self = self else {
                    return
                }
                self.presenter.restartGame()
            })
        presenter.alertPresenter?.showAlert(result: alertModel)
    }
}

