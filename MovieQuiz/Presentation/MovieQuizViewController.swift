import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
        alertPresenter = AlertPresenter(viewController: self)
        statisticService = StatisticServiceImplementation()
        presenter.viewController = self
        
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError (message:String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") {[weak self]_ in
            guard self != nil else {return}
            self!.presenter.questionFactory?.loadData()
            self!.showLoadingIndicator()
        }
        alertPresenter?.show(results: model)
    }
    
    // Заполнение картинки и текста данными
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // Отоброжение результата прохождения квиза
    func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title,
                                    message: result.text,
                                    buttonText: result.buttonText) {[weak self]_ in
            guard self != nil else {return}
            self?.presenter.restartGame()
        }
        self.alertPresenter?.show(results: alertModel)
        self.counterLabel.text = "1/10"
        self.presenter.resetQuestionIndex()
        presenter.correctAnswers = 0
        self.presenter.questionFactory?.requestNextQuestion()
        
        
    }
    
     func showAnswerResult(isCorrect: Bool) {
         if isCorrect {presenter.correctAnswers += 1
        }
        if presenter.isLastQuestion()  {
            showNextQuestionOrResults()
            return
        }
        // Создание рамки с цветом, который соответствует ответу
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.borderWidth = 8
        self.imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor: UIColor.ypRed.cgColor
        self.presenter.switchToNextQuestion()
        
        // Показ следующего вопроса с задержкой в 1 секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.presenter.questionFactory?.requestNextQuestion()
            self.imageView.layer.borderWidth = 0
            
        }
    }
    
    func showNextQuestionOrResults() {
        presenter.showNextQuestionOrResults()
    }

}


