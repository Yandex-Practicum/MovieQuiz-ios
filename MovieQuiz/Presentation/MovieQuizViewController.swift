import UIKit


final class MovieQuizViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        imageView.layer.cornerRadius = 20
        textLabel.textColor = .ypWhite
        textLabel.font = .boldSystemFont(ofSize: 23)
    }
    
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        disableButtons()
        presenter.noButtonClicked()  
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        disableButtons()
        presenter.yesButtonClicked()
    }
    
    // MARK: - Functions
    
    func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
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
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        // здесь мы показываем верно или нет ответил пользователь
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func disableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func enableButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
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
}

