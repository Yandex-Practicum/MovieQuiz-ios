import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
           
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    var alertPresenter: AlertPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(viewController: self)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        let show = true
        bootonIsDisabled (show)
    }

    func printAlert (alertModel: AlertModel) {
        alertPresenter?.show(alertModel: alertModel)
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
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.resetQuestionIndex()
            self.presenter.restartGame()
        }
        
        alertPresenter?.show(alertModel: model)
    }
    
    private func bootonIsDisabled (_ show: Bool) {
        if !show {
            yesButton.isEnabled = false
            noButton.isEnabled = false
        } else {
            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let show = false
        bootonIsDisabled (show)
        presenter.yesButtonClicked()
    }
       
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let show = false
        bootonIsDisabled (show)
        presenter.noButtonClicked()
    }
   
    
}


