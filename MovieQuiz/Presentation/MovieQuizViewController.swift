import UIKit

final class MovieQuizViewController: UIViewController  {
    
        
    // MARK: - Lifecycle

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    //private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    private var presenter: MovieQuizPresenter!
    
    weak var buttonNo: UIButton!
    weak var buttonYes: UIButton!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        
        imageView.layer.cornerRadius = 20
        //questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()

        //questionFactory?.loadData()
        showLoadingIndicator()
    }
    
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - Private functions
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    func show(quiz result: QuizResultsViewModel) {
        var message = result.text
        if let statisticService = statisticService {
            statisticService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)

            let bestGame = statisticService.bestGame

            let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
            let currentGameResultLine = "Ваш результат: \(presenter.correctAnswers)\\\(presenter.questionsAmount)"
            let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)" + " (\(bestGame.date.dateTimeString))"
            let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"

            let resultMessage = [
                currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
            ].joined(separator: "\n")

            message = resultMessage
        }

        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)

        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()

            //self.questionFactory?.requestNextQuestion()
        }

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }
    
    func showAnswerResult(isCorrect: Bool) {
        
//        if isCorrect {
//            correctAnswers += 1
//        }
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        
        //buttonYes.isEnabled = true
        //buttonNo.isEnabled = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.showNextQuestionOrResults()
        }
    }

    func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            let text = "Вы ответили на \(presenter.correctAnswers) из 10, попробуйте еще раз!"

            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            presenter.switchToNextQuestion()
            //questionFactory?.requestNextQuestion()
        }
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func showNetworkError(message: String) {
        activityIndicator.isHidden = true // скрываем индикатор загрузки

        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)

        let action = UIAlertAction(title: "Попробовать еще раз",
                                   style: .default) { [weak self] _ in
            guard let self = self else { return }

//            self.presenter.resetQuestionIndex()
//            self.correctAnswers = 0
            self.presenter.restartGame()

            //self.questionFactory?.requestNextQuestion()
        }

        alert.addAction(action)
    }
    
    // MARK: - AlertPresenterDelegate
    
    func didShowAlert(controller: UIAlertController?) {
        guard let controller = controller else {
            return
        }
        present(controller, animated: true, completion: nil)

    }
    
    // MARK: Индикатор загрузки
    
    func hideLoadingIndicator() {
         activityIndicator.isHidden = true
         //activityIndicator.stopAnimating()
     }
    
    
}
