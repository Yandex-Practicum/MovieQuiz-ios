import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    //private var correctAnswers = 0
    private var isButtonEnabled = true
    //var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    //private var presenter = MovieQuizPresenter()
    private var presenter: MovieQuizPresenter!

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        imageView.layer.cornerRadius = 20
        showLoadingIndicator()
        imageView.layer.cornerRadius = 20
        
        //questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        alertPresenter = AlertPresenterImpl(viewController: self)
        statisticService = StatisticServiceImplentation(userDefaults: UserDefaults(), decoder: JSONDecoder(), encoder: JSONEncoder())
        
        
        //questionFactory?.loadData()
        
    }
    
    // MARK:  - QuestionFactoryDelegate
    //func didRecieveNextQuestion(question: QuizQuestion?) {
        //presenter.didRecieveNextQuestion(question: question)
    //}
    
    
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        statisticService?.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
        
    }
    
    func showAnswerResult(isCorrect: Bool) {
        presenter.didAnswer(isCorrectAnswer: isCorrect)
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.imageView.layer.borderColor = nil
                self.imageView.layer.borderWidth = 0
                //self.presenter.questionFactory = self.questionFactory
                self.presenter.showNextQuestionOrResults()
                
                
            }
            
       /* } else {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypRed.cgColor
           
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.imageView.layer.borderColor = nil
                self.imageView.layer.borderWidth = 0
                self.presenter.showNextQuestionOrResults()
                self.presenter.questionFactory = self.questionFactory
            }*/
        //}
}
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    
    
     func showFinalResults() {
         statisticService?.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
        
        guard (statisticService?.bestGame) != nil else {
            assertionFailure("error message")
            return
        }
        
        let alertModel = AlertModel(
            title: "Игра Окончена",
            message: makeResultMessage(),
            buttonText: "OK",
            completion: { [weak self] in
                self?.presenter.restartGame()
                self?.presenter.correctAnswers = 0
                //self?.questionFactory?.requestNextQuestion()
                //viewController?.show(quiz: viewModel)
            }
        )
        alertPresenter?.show(alertModel: alertModel)
        
    }
    
     func makeResultMessage() -> String {
        guard let statisticService = statisticService,
              let bestGame = statisticService.bestGame else {
            assertionFailure("errroor")
            return ""
        }
        
        let accuracy = String(format: "%.2f",statisticService.totalAccuracy)
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
         let currentGameResultLine = "Ваш результат, \(presenter.correctAnswers)\\ \(presenter.questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(accuracy)%"
        
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        return resultMessage
    }
     func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
     func showNetworkError(message: String) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
            self.presenter.correctAnswers = 0
            
            //self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.show(alertModel: model)
    }
    
    //func didLoadDataFromServer() {
        //activityIndicator.isHidden = true
       // questionFactory?.requestNextQuestion()
   // }
    
    //func didFailToLoadData(with error: Error) {
       // showNetworkError(message: error.localizedDescription)
   // }
}

