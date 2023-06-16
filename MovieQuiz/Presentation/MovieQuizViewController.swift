import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didRecieveNextQuestion(question: question)
    }
    
    private var statisticService: StatisticService?
    private var questionFactory: QuestionFactoryProtocol?
    
    private var correctAnswers = 0
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewController = self
        
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 20
        
        statisticService = StatisticServiceImplementation()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    func show(quiz step: QuizStepViewModel) {
        self.counterLabel.text = step.questionNumber
        self.imageView.image = step.image
        self.textLabel.text = step.question
    }
    
    // приватный метод для показа результатов раунда квиза
    // принимает вью модель QuizResultsViewModel и ничего не возвращает
    func show(quiz result: QuizResultsViewModel) {
        let action: (() -> Void) = { [weak self] in
            guard let self = self else { return }
            
            self.correctAnswers = 0
            
            self.presenter.resetQuestionIndex()
            self.questionFactory?.requestNextQuestion()
        }
        
        self.statisticService?.store(correct: correctAnswers, total: presenter.getQuestionAmount())
        
        let message: String
        
        if let gamesCount = self.statisticService?.gamesCount,
           let correct = self.statisticService?.bestGame.correct,
           let total = self.statisticService?.bestGame.total,
           let date = self.statisticService?.bestGame.date,
           let totalAccuracy = self.statisticService?.totalAccuracy {
            message =
            "Ваш результат: \(self.correctAnswers)/\(self.presenter.getQuestionAmount())\n" +
          "Количество сыгранных квизов: \(gamesCount)\n" +
            "Рекорд: \(correct)/\(total) (\(date.dateTimeString))\n" +
          "Средняя точность: \(String(format: "%.2f", totalAccuracy))%"
        } else {
            message = result.text
        }
        
        let alertModel = AlertModel(
            title: result.title,
            message: message,
            buttonText: result.buttonText,
            completion: action)
        
        let alertPresenter = AlertPresenter(controller: self, model: alertModel)
        alertPresenter.run()
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            self.correctAnswers += 1
            self.imageView.layer.borderColor = UIColor(named: "YP Green")?.cgColor
        } else {
            self.imageView.layer.borderColor = UIColor(named: "YP Red")?.cgColor
        }
        
        self.imageView.layer.borderWidth = 8
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.imageView.layer.borderWidth = 0
            
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        
        let action: (() -> Void) = { [weak self] in
            guard let _ = self else { return }
            // действия при нажатии на кнопку алерта
        }
        
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: action)
        
        self.presenter.resetQuestionIndex()
        self.correctAnswers = 0

        self.questionFactory?.requestNextQuestion()
        
        let alertPresenter = AlertPresenter(controller: self, model: alertModel)
        alertPresenter.run()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }

    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
}
