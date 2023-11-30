import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: -Properties
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    //вызываем алерт презентер
    private var alertPresenter: AlertPresenter?
    //обьявляем презентер
    private var presenter: MovieQuizPresenter!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        alertPresenter =  AlertPresenter (view: self)
        
        showLoadingIndicator()
    }
    
    //MARK: - actions
    //если нажал кнопку нет
    @IBAction private func noButtonClicked(_ sender: UIButton)  {
        presenter.noButtonClicked()
    }
    //если нажал кнопку да
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    //MARK: - private functions
    //приватный метод вывода на экран вопроса который принимает на вход вью модель вопроса и ничего не возвращает
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.questions
        counterLabel.text = step.questionNumber
    }
    
    //метод состояния индикатора загрузки
    func showLoadingIndicator() {
        //говорит что индикатор загрузки не скрыт
        activityIndicator.isHidden = false
        //включаем анимацию
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    //методы для скрытия/показа кнопок да и нет
    func enebleButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func disableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    //алерт показа ошибки загрузки
    func showNetworkError(message: String) {
        //cкрываем индикатор загрузки
        hideLoadingIndicator()
        
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще один раз",
            buttonAction:  { [weak self] in
                self?.presenter.restartGame()
            }
        )
        alertPresenter?.show(data: model)
        //TODO: hbkhbjh
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
        //метод красит рамку
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func noImageBorder() {
        //убираем границу рамки
        imageView.layer.borderWidth = 0
    }
    
    func showFinalResults() {
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: presenter.makeResultMessage(),
            buttonText: "Сыграть еще раз!",
            buttonAction: { [weak self] in
                self?.presenter.restartGame()
            }
        )
        
        alertPresenter?.show(data: alertModel)
    }
}
