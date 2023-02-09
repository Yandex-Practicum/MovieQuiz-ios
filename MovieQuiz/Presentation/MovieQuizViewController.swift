import UIKit

protocol MovieQuizViewProtocol: AnyObject {
    func show(quiz: QuizStepViewModel)
    func highLightImageBorder(isCorrect: Bool)
    func setupActivityIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func finishAlert()
    func blockingButton()
}

final class MovieQuizViewController: UIViewController, MovieQuizViewProtocol {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent}
    // MARK: - Outlets
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private var alertPresenter: AlertPresenterDelegate?
    private var presenter: MovieQuizPresenter!
    
    func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .ypBlack
        activityIndicator.startAnimating()
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    func hideLoadingIndicator(){
        activityIndicator.isHidden = true
    }
    
    func blockingButton() {
        self.noButton.isEnabled.toggle()
        self.yesButton.isEnabled.toggle()
    }
    
    func showQuizResult(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default) { _ in model.comletion()}
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        alert.view.accessibilityIdentifier = "alert"
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        UIView.transition(with: imageView,
                          duration: 0.3,
                          animations: {self.imageView.image = step.image })
    }
    
    func finishAlert() {
        let message = presenter.makeResultMessage()
        let alert = AlertModel(title: "Этот раунд окончен!",
                               message: message,
                               buttonText: "Сыграть еще раз") { [weak self] in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        alertPresenter?.show(model: alert)
    }
    
            
    func highLightImageBorder(isCorrect: Bool){
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alert = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") {
            [weak self] in guard let self = self else {return}
            self.presenter.restartGame()
        }
        alertPresenter?.show(model: alert)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter()
        alertPresenter?.didLoad(self)
    }
}


