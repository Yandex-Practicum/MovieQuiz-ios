import UIKit

final class MovieQuizViewController: UIViewController {
    
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
    private var statisticService: StatisticService?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius  = 20
        imageView.layer.masksToBounds = true
        alertPresenter = AlertPresenter(viewController: self)
        presenter = MovieQuizPresenter(viewController: self)
        statisticService = StatisticServiceImplementation()
        presenter.questionFactory?.loadData()
        showLoadingIndicator()
        presenter.viewController = self
    }
    
    @IBAction private func noButtonAction(_ sender: Any) {
        presenter.noButtonAction()
    }
    @IBAction private func yesButtonAction(_ sender: Any) {
        presenter.yesButtonAction()
    }
    
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        yesButtonOutlet.isUserInteractionEnabled = false
        noButtonOutlet.isUserInteractionEnabled = false
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {
            presenter.correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.imageView.layer.borderWidth = 0
            self.presenter.alertPresenter = self.alertPresenter
            self.presenter.statisticService = self.statisticService
            self.presenter.showNextQuestionOrResults()
            self.yesButtonOutlet.isUserInteractionEnabled = true
            self.noButtonOutlet.isUserInteractionEnabled = true
        }
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
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
             hideLoadingIndicator()

             let alertModel = AlertModel(title: "Ошибка",
                                         message: message,
                                         buttonText: "Попробовать ещё раз") {
                        [weak self] in
                        guard let self = self else {return}
                        self.presenter.questionFactory?.loadData()
                        self.showLoadingIndicator()
             }
         self.presenter.restartGame()
         alertPresenter?.show(results: alertModel)
         }
}
