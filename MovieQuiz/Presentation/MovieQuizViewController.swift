import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: -Properties
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //вызываем алерт презентер
    private var alertPresenter: AlertPresenter?
    //private var statisticService: StatisticService?
    //обьявляем презентер
    private var presenter: MovieQuizPresenter!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        alertPresenter = AlertPresenterImpl(viewController: self)
        
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
        textLabel.text = step.question
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
    //алерт показа ошибки загрузки
    func showNetworkError(message: String) {
        //cкрываем индикатор загрузки
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз",
                               buttonAction:  { [weak self] in
            self?.presenter.restartGame()
        }
        )
        alertPresenter?.show(alertModel: model)
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
        
        
        alertPresenter?.show(alertModel: alertModel)
    }
}
