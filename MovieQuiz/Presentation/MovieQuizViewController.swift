import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {

    // MARK: - Outlet
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var presenter: MovieQuizPresenter!
    var vSpinner : [UIView] = []
    private var alertPresenter: AlertPresenter?
   

    //MARK: - View Did Loade
    
    override func viewDidLoad(){

        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        alertPresenter = AlertPresenter(viewController: self)
        showLoadingIndicator()
        presenter = MovieQuizPresenter(viewController: self)
    }
    
   
        
    // MARK: - Private functions
    
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
    
    func extinguishImageBorder() {
        imageView.layer.borderWidth = 0
    }
    
    func showNetworkError(message: String) {
      
        let networkError = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") { [weak self] _ in
            guard let self = self else {return}
            self.presenter.restartGame()
            
            
        }
        alertPresenter = AlertPresenter(viewController: self)
        alertPresenter?.showAlert(quiz: networkError)
    }
    
   func show(quiz step: QuizStepViewModel){
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    
    func show(quiz result: QuizResultsViewModel) {
            let alertModel = AlertModel(
                title: result.title,
                message: result.text,
                buttonText: result.buttonText)
            { [weak self] _ in
                guard let self = self else { return }
                self.presenter.restartGame()
            }
            alertPresenter?.showAlert(quiz: alertModel)
        }
        
    
    private func blockButtons() {
            yesButton.isEnabled = false
            noButton.isEnabled = false
        showLoadingIndicator()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else {return}
                self.yesButton.isEnabled = true
                self.noButton.isEnabled = true
                self.hideLoadingIndicator()
        }
    }
    

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
        blockButtons()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
        blockButtons()
    }

}

