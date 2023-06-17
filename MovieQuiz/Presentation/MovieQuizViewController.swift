import UIKit

final class MovieQuizViewController: UIViewController {
    private var statisticService: StatisticService?
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 20
        
        statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    func show(quiz step: QuizStepViewModel) {
        self.counterLabel.text = step.questionNumber
        self.imageView.image = step.image
        self.textLabel.text = step.question
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let action: (() -> Void) = { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        
        self.statisticService?.store(correct: presenter.correctAnswers, total: presenter.getQuestionAmount())
        
        let message: String
        
        if let gamesCount = self.statisticService?.gamesCount,
           let correct = self.statisticService?.bestGame.correct,
           let total = self.statisticService?.bestGame.total,
           let date = self.statisticService?.bestGame.date,
           let totalAccuracy = self.statisticService?.totalAccuracy {
            message =
            "Ваш результат: \(presenter.correctAnswers)/\(presenter.getQuestionAmount())\n" +
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
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        
        if isCorrect {
            imageView.layer.borderColor = UIColor(named: "YP Green")?.cgColor
        } else {
            imageView.layer.borderColor = UIColor(named: "YP Red")?.cgColor
        }
        
        imageView.layer.borderWidth = 8
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.imageView.layer.borderWidth = 0
            
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let action: (() -> Void) = { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: action)
        
        let alertPresenter = AlertPresenter(controller: self, model: alertModel)
        alertPresenter.run()
    }
}
