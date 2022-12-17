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

    //MARK: - View Did Loade
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
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
    
    func show(quiz step: QuizStepViewModel){
       counterLabel.text = step.questionNumber
       imageView.image = step.image
       textLabel.text = step.question
       imageView.layer.borderColor = UIColor.clear.cgColor
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
        alert.view.accessibilityIdentifier = "Alert"

        self.present(alert, animated: true, completion: nil)
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
      
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
        
    }

}

