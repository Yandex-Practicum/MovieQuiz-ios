import UIKit

// MARK: - MovieQuizViewController Class Protocol
protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func show(quizStep model: QuizStepViewModel)
    func show(alert model: AlertModel)
    func toggleButtons(to state: Bool)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator(is state: Bool)
}

// MARK: - MovieQuizViewController Class
final class MovieQuizViewController: UIViewController {
    
    // MARK: - Properties
    // Outlets
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var counerLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    /// Презентер из MVP
    private var presenter: MovieQuizPresenter?
    /// Фабрика уведомлений
    private var alertPresenter: AlertPresenter?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        activityIndicator.hidesWhenStopped = true
        
        // Формирование зависимостей
        alertPresenter = AlertPresenter(delegate: self)
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - IBActions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter?.didAnswer(isYes: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter?.didAnswer(isYes: false)
    }
}
// MARK: - MovieQuizViewControllerProtocol Methods

extension MovieQuizViewController: MovieQuizViewControllerProtocol {
    
    /// Смена декораций представления/view
    ///  - Parameters:
    ///     - quizStep: QuizStepViewModel-структура, содержащая необходимые элементы для обновления представления
    ///
    func show(quizStep model: QuizStepViewModel){
        
        // Убираем окраску рамки изображения
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        // Адаптируем интерфейс под новый вопрос
        counerLabel.text = model.questionNumber
        imageView.image = model.image
        textLabel.text = model.question
        
        // Включаем кнопки
        toggleButtons(to: true)
    }
    
    /// Отображение уведомления/алерта
    ///  - Parameters:
    ///     - alert: Параметры уведомления в формате AlertModel
    func show(alert model: AlertModel) {
        alertPresenter?.alert(with: model)
    }
    
    /// Метод включающий/выключающий кнопки ответов
    ///  - Parameters:
    ///     - to: Состояние в которое переводится свойство кнопок isEnabled, true - включаем кнопки, false - отключаем
    func toggleButtons(to state: Bool){
        noButton.isEnabled = state
        yesButton.isEnabled = state
    }
    
    /// Окрашиваем цвет рамки изображения в зависимости от верности ответа
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    /// Прячем/отображаем индикатор активности
    func showLoadingIndicator(is state: Bool){
        if state {
            activityIndicator.startAnimating()
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

