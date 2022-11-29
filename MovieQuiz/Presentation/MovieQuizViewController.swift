import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {

    // MARK: - Lifecycle
        
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    private var correctAnswers: Int = 0
    
    private var presenter = MovieQuizPresenter()
    private var questionFactory: QuestionFactoryProtocol?
    private var alertModel: AlertModel?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticsService: StatisticServiceProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewController = self
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        statisticsService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        questionFactory?.loadData()
        showLoadingIndicator()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }

    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    
    // MARK: - AlertPresenterDelegate
    
    func alertPresent(alert: UIAlertController?) {
        guard let alert = alert else {
            return
        }
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Private functions
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = AlertModel(
            title: "Ошибка",
            message: "Произошла ошибка сети",
            buttonText: "Попробовать еще раз") { [weak self] _ in
                guard let self = self else { return }
                self.restart()
            }
        
        alertPresenter = AlertPresenter(alertDelegate: self)
        alertPresenter?.makeAlertController(alertModel: alert)
    }
    
    private func restart() {
        self.presenter.resetQuestionIndex()
        self.questionFactory?.requestNextQuestion()
        self.correctAnswers = 0
    }
    
    func showFinalAlert() {
        
        let text = "Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)\nКоличество сыгранных квизов: \(String(describing: statisticsService!.gamesCount))\nРекорд: \(String(describing: statisticsService!.bestGame.correct))/\(String(describing: statisticsService!.bestGame.total)) (\(String(describing: statisticsService!.bestGame.date.dateTimeString)))\nСредняя точность: \(String(format: "%.2f", statisticsService!.totalAccuracy))%"
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: text,
            buttonText: "Сыграть ещё раз") { [weak self] _ in
                guard let self = self else { return }
                self.restart()
            }
        
        if let statisticsService = statisticsService { statisticsService.store(correct: correctAnswers, total: presenter.questionsAmount) }
        
        alertPresenter = AlertPresenter(alertDelegate: self)
        alertPresenter?.makeAlertController(alertModel: alertModel)
        
        
    }
    
    func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.image = step.image
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }

        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen?.cgColor : UIColor.ypRed?.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory as? QuestionFactory
            self.presenter.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
        }
    }
}
