import UIKit
//

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate, MovieQuizViewControllerProtocol {
    
    // связь объектов из main-экрана с контроллером
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var alertPresenter: AlertPresenter?
    private var presenter: MovieQuizPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // настраиваем внешний вид рамки
        setupImageView()
        // стартуем новый раунд
        startNewRound()
    }
    
    // MARK: Визуализация
    
    // приватный метод визуализации рамки
    private func setupImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
    }
    
    // приватный метод отключения/включения кнопок
    func setAnswerButtonsEnabled(_ enabled: Bool) {
        noButton.isEnabled = enabled
        yesButton.isEnabled = enabled
    }
    
    // визуализация индикатора загрузки
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    // визуализация индикатора загрузки
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true // говорим, что индикатор загрузки скрыт
        activityIndicator.stopAnimating() // выкллючаем анимацию
    }
    
    // визуализация рамки
    func showQuestionAnswerResult(isCorrect: Bool) {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        })
    }
    
    // визуализация результата раунда
    func showQuizResults(model: AlertModel?) {
        guard let alertModel = model else {
            return
        }
        alertPresenter?.present(alertModel: alertModel, on: self)
    }
    
    // визуализация отображения ошибок
    func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        
        let alertModel = AlertModel(title: "Ошибка!", message: message, buttonText: "Попробовать еще раз")
        alertPresenter?.present(alertModel: alertModel, on: self)
    }
    
    // визуализация вывода на экран вопроса
    func showQuestion(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    // MARK: Обработка логики нажатий и логики показов
    
    // нажатие на кнопку нет
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        setAnswerButtonsEnabled(false)
        presenter?.noButtonClicked()
    }
    
    // нажатие на кнопку да
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        setAnswerButtonsEnabled(false)
        presenter?.yesButtonClicked()
    }
    
    // метод запускает отображение нового раунда
    private func startNewRound() {
        showLoadingIndicator()
        alertPresenter = AlertPresenter()
        alertPresenter?.delegate = self
        presenter = MovieQuizPresenter(viewController: self)
        setAnswerButtonsEnabled(true)
    }
    
    // делаем если алерт был показан
    func alertDidDismiss() {
        startNewRound()
    }
}
