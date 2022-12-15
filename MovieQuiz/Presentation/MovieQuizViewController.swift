import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol, ResultAlertPresenterDelegate {
    
        
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: ResultAlertPresenter!
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private var noButton: UIButton!
    
    @IBOutlet private var yesButton: UIButton!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = ResultAlertPresenter(delegate: self)
        presenter = MovieQuizPresenter(controller: self)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.cornerRadius = 20
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func showNetworkError(message: String) {
        activityIndicator.isHidden = true
        let alert = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") { [weak self] _ in
            guard let self = self else {return}
            self.presenter.restartGame()
        }
        alertPresenter.present(alert: alert, style: .alert)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        let alert = AlertModel(title: result.title,
                               message: message,
                               buttonText: result.buttonText) { [weak self] _ in
            guard let self = self else {return}
            self.presenter.restartGame()
            
        }
        
        alertPresenter.present(alert: alert, style: .alert)
    }
    
    
    func resetAnwserResult() {
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func highlightBorders(isCorrect: Bool) {
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func enableAnswerButtons() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    func disableAnswerButtons() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    //MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    //MARK: - ResultAlertPresenterDelegate
    
    func didRecieveAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
}
