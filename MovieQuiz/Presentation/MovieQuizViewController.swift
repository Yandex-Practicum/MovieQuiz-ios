import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol, AlertPresenterDelegate {
    
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var buttonsStackView: UIStackView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterProtocol? = AlertPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        imageView.layer.cornerRadius = 20
        showLoadingIndicator()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    internal func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    internal func alertPresenterDidPresent() {
        presenter.restartGame()
        presenter.questionFactory?.requestNextQuestion()
    }
    
    internal func showLoadingIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    internal func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
        }
    }
    internal func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self]  in
            guard let self = self else { return }
            self.showLoadingIndicator()
            presenter?.questionFactory?.loadData()
        }
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        alertPresenter.showAlert(with: model)
    }
    
    internal func highlightImageBorder(isCorrect: Bool) {
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ?  UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        buttonsStackView.isUserInteractionEnabled = false
        
    }
    
    func show(quiz step: QuizStepViewModel) {
        self.hideLoadingIndicator()
        buttonsStackView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 0
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    
    internal func showResult(quiz result: AlertModel) {
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        alertPresenter.showAlert(with: result)
    }
}


