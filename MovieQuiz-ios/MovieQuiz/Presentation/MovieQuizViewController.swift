import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - Lifecycle
    
    
    
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var countLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    
    @IBOutlet weak private var noButton: UIButton!
    
    @IBOutlet weak private var yesButton: UIButton!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        disableButtons()
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        disableButtons()
        presenter.noButtonClicked()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        
        presenter = MovieQuizPresenter(viewController: self)
    
    }
    
    func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        countLabel.text = step.questionNumber
        questionLabel.text = step.question
    }
    
    func showAlert(quiz result: QuizResultsViewModel) {
        
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.restartQuiz()
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
        alert.view.accessibilityIdentifier = "Final game"
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor(named: "YP Green")?.cgColor : UIColor(named: "YP Red")?.cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    
    func showNetworkError(message: String) { // функция которая покажет, что произошла ошибка
        hideLoadingIndicator() // скрываем индикатор загрузки
        
        let alertError = UIAlertController(    // создаем и показываем алерт
            title: "Что-то пошло не так(",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: "Попробовать еще раз?",
                                   style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.didLoadDataFromServer()
        }
        alertError.addAction(action)
        
        self.present(alertError, animated: true, completion: nil)
    }
    
    func disableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func enableButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
}

