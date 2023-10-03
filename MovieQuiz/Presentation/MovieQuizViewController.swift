import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = MovieQuizPresenter(viewController: self)
        
        alertPresenter = AlertPresenterImpl(viewController: self)

        showLoadingIndicator()
    }
    /*
    //MARK: -QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    */
    //MARK: - actions
    //если нажал кнопку нет
    @IBAction private func noButtonClicked(_ sender: UIButton)  {
        presenter.noButtonClicked()
    }
    //если нажал кнопку да
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
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
    
    // константа с кнопкой для системного алерта
    
   // private let alert = UIAlertController(
   //     title: "Этот раунд окончен!",
   //     message: "Ваш результат ???",
   //     preferredStyle: .alert)
    
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
