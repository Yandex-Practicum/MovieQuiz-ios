import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - private Outlet Variables
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var yesButtonOutlet: UIButton!
    @IBOutlet private weak var noButtonOutlet: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables and lets
    private var presenter: MovieQuizPresenter!
    var alertPresenter: AlertPresenterProtocol?
    
    // MARK: -  viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius  = 20
        imageView.layer.masksToBounds = true
        alertPresenter = AlertPresenter(viewController: self)
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
        presenter.viewController = self
    }
    
    // MARK: - IBAction private functions
    @IBAction private func noButtonAction(_ sender: Any) {
        presenter.noButtonAction()
    }
    
    @IBAction private func yesButtonAction(_ sender: Any) {
        presenter.yesButtonAction()
    }
    
    // MARK: - private functions
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        interactionDisable()
    }
    
    func interactionEnable(){
        self.imageView.layer.borderWidth = 0
        self.yesButtonOutlet.isEnabled = true
        self.noButtonOutlet.isEnabled = true
    }
    
    func interactionDisable(){
        self.yesButtonOutlet.isEnabled = false
        self.noButtonOutlet.isEnabled = false
    }
    
    func show(quiz step: QuizStepViewModel) { //метод показа вопроса
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber// здесь мы заполняем нашу картинку, текст и счётчик данными
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true // говорим, что индикатор загрузки скрыт
        activityIndicator.stopAnimating() //выключаем индикатор
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertModel = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробовать ещё раз") {
            [weak self] in
            guard let self = self else {return}
            self.presenter.factoryLoadData()
            self.showLoadingIndicator()
        }
        self.presenter.restartGame()
        alertPresenter?.show(results: alertModel)
    }
}
