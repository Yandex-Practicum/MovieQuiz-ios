import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {

    // MARK: - Lifecycle
        
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    private var correctAnswers: Int = 0
    
    private var presenter = MovieQuizPresenter()
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
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
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }

    // MARK: - QuestionFactoryDelegate

    internal func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    internal func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    internal func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    
    // MARK: - AlertPresenterDelegate
    
    internal func alertPresent(alert: UIAlertController?) {
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
    
    private func showFinalAlert() {
        
        let text = "Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)\nКоличество сыгранных квизов: \(String(describing: statisticsService!.gamesCount))\nРекорд: \(String(describing: statisticsService!.bestGame.correct))/\(String(describing: statisticsService!.bestGame.total)) (\(String(describing: statisticsService!.bestGame.date.dateTimeString)))\nСредняя точность: \(String(format: "%.2f", statisticsService!.totalAccuracy))%"
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: text,
            buttonText: "Сыграть ещё раз") { [weak self] _ in
                guard let self = self else { return }
                self.restart()
            }
        alertPresenter = AlertPresenter(alertDelegate: self)
        alertPresenter?.makeAlertController(alertModel: alertModel)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.image = step.image
    }
    
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen?.cgColor;
            correctAnswers += 1 }
        else {
            imageView.layer.borderColor = UIColor.ypRed?.cgColor }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
        }
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            statisticsService?.store(correct: correctAnswers, total: presenter.questionsAmount)
            showFinalAlert()
            
          } else {
              presenter.switchtoNextQuestion()
              questionFactory?.requestNextQuestion()
          }
    }  
}
