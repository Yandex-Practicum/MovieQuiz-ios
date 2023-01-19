import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    private var alertPresenter: AlertPresenterProtocol?
    private var presenter: MovieQuizPresenter!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(viewController: self)
    }
    
    // Заполнение картинки и текста данными
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // Отоброжение результата прохождения квиза
    func show(quiz result: QuizResultsViewModel) {
        _ = presenter.makeResultsMessage()
        let alertModel = AlertModel(title: result.title,
                                    message: result.text,
                                    buttonText: result.buttonText) {[weak self]_ in
            guard self != nil else {return}
            self?.presenter.restartGame()
        }
        
        
        self.alertPresenter?.show(results: alertModel)
        
        self.presenter.resetQuestionIndex()
        presenter.correctAnswers = 0
        self.presenter.questionFactory?.requestNextQuestion()
        
        
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    

    
    // Ошибка
    func showNetworkError (message:String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") {[weak self]_ in
            guard self != nil else {return}
            self!.presenter.questionFactory?.loadData()
            self!.showLoadingIndicator()
        }
        alertPresenter?.show(results: model)
    }
    
    // Рамка и цвет в зависимости от правильности ответа
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    func imageBorderOff() {
        sleep(1)
        imageView.layer.borderWidth = 0
    }
}


