import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    private let alertPresenter = AlertPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        settingUI()
    }
    
    // MARK: - Actions
    
    @IBAction private func noButtonPressed(_ sender: Any) {
        chooseIsEnableButtons(false)
        presenter.noButtonPressed()
    }
    
    @IBAction private func yesButtonPressed(_ sender: Any) {
        chooseIsEnableButtons(false)
        presenter.yesButtonPressed()
    }
    
    // MARK: - Private functions
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        questionLabel.text = step.question
        hideLoadingIndicator()
    }
    
    func showAlert() {
        let message = presenter.makeResultMessage()
        
        let alert = AlertModel(
            title: "Раунд окончен!",
            message: message,
            buttonText: "Сыграть ещё раз",
            completion: {[weak self] in
                guard let self = self else { return }
                self.presenter.resetGame()
            }
        )
        alertPresenter.showAlert(model: alert, from: self)
    }
    
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    
    func chooseIsEnableButtons(_ enabled: Bool){
        yesButton.isEnabled = enabled
        noButton.isEnabled = enabled
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            showLoadingIndicator()
            self.presenter.resetGame()
        }
        
        alertPresenter.showAlert(model: model, from: self)
    }
    
    // MARK: - Setting UI
    
    private func settingUI() {
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        imageView.layer.cornerRadius = 20
        yesButton.layer.cornerRadius = 15
        noButton.layer.cornerRadius = 15
        activityIndicator.color = .white
    }
    
}

extension MovieQuizViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
