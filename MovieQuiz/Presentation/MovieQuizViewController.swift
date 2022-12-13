import UIKit


final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterProtocol? = AlertPresenter()
    @IBOutlet private var nobutton: UIButton!
    @IBOutlet private var yesbutton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(viewController: self)
        
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    func yesButtonIsEnabled(result: Bool) {
        yesbutton?.isEnabled = result
    }
    
    func noButtonIsEnabled(result: Bool) {
        nobutton?.isEnabled = result
    }
    
    func showLoadingIndicator() {
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator?.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] _ in guard let self = self else {return}
            
            self.showLoadingIndicator()
            self.presenter.restartGame()
        }
        alertPresenter?.show(results: model)
    }
    
    func hightLightImageBorder(isCorrectAnswer: Bool) {
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor(named: "YP Green")?.cgColor : UIColor(named: "YP Red")?.cgColor
        imageView.layer.cornerRadius = 20
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title, message: result.text , buttonText: result.buttonText) {[weak self] _ in guard let self = self else {return}
            self.presenter.restartGame()
        }
        alertPresenter?.show(results: alertModel)
        
    }
    
}


