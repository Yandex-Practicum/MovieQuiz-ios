import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate {

    // MARK: - Lifecycle
        
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    private var presenter: MovieQuizPresenter!
    private var alertModel: AlertModel?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticsService: StatisticServiceProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
// MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        statisticsService = StatisticServiceImplementation()
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - AlertPresenterDelegate
    
    func alertPresent(alert: UIAlertController?) {
        guard let alert = alert else {
            return
        }
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Private functions
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = AlertModel(
            title: "Ошибка",
            message: "Произошла ошибка сети",
            buttonText: "Попробовать еще раз") { [weak self] _ in
                guard let self = self else { return }
                self.presenter.restartGame()
            }
        
        alertPresenter = AlertPresenter(alertDelegate: self)
        alertPresenter?.makeAlertController(alertModel: alert)
    }
    
    func showFinalAlert() {
        
        let text = "Ваш результат: \(presenter.correctAnswers)/\(presenter.questionsAmount)\nКоличество сыгранных квизов: \(String(describing: statisticsService!.gamesCount))\nРекорд: \(String(describing: statisticsService!.bestGame.correct))/\(String(describing: statisticsService!.bestGame.total)) (\(String(describing: statisticsService!.bestGame.date.dateTimeString)))\nСредняя точность: \(String(format: "%.2f", statisticsService!.totalAccuracy))%"
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: text,
            buttonText: "Сыграть ещё раз") { [weak self] _ in
                guard let self = self else { return }
                self.presenter.restartGame()
            }
        
        if let statisticsService = statisticsService { statisticsService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount) }
        
        alertPresenter = AlertPresenter(alertDelegate: self)
        alertPresenter?.makeAlertController(alertModel: alertModel)
        
        
    }
    
    func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.image = step.image
    }
    
    func showAnswerResult(isCorrect: Bool) {
        presenter.didAnswer(isCorrectAnswer: isCorrect)

        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen?.cgColor : UIColor.ypRed?.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
        }
    }
}
