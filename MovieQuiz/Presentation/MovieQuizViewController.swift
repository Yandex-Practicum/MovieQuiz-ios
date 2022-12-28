import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate, MovieQuizViewControllerProtocol {

    // MARK: - Lifecycle
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!

    var alertPresenter: AlertPresenter?
    private var presenter: MovieQuizPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter()
        alertPresenter?.delegate = self

    }
   
    
    // MARK: - AlertPresenterDelegate
   func didPresentAlert(alert: UIAlertController?) {
        guard let alert = alert else {
            return
        }
        DispatchQueue.main.async {[weak self] in
        self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func show(quiz quizStepViewModel: QuizStepViewModel) {

        imageView.image = quizStepViewModel.image
        imageView.layer.cornerRadius = 20
        textLabel.text = quizStepViewModel.question
        counterLabel.text = quizStepViewModel.questionNumber
        
    }
    

    func highLightImageBorder (isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        if isCorrectAnswer {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            presenter.didAnswer(isCorrect: true)
        } else{
            imageView.layer.borderColor = UIColor.ypRed.cgColor
            
        }
    }
    
    func hideBorder() {
        imageView.layer.borderWidth = 0
    }
    
    func buttonsEnable(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertModelResult = AlertModel(title: "Ошибка",
                                          message: message,
                                          buttonText: "Попробовать еще раз",
                                          completion: { [weak self] _ in
                                                        guard let self = self else {
                                                            return
                                                        }
                                           self.presenter.restartGame()
                                        })
        alertPresenter?.showResult(alertModel: alertModelResult)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
