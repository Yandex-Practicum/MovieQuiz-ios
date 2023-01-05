import UIKit

final class MovieQuizViewController: UIViewController {
    //MARK: - Lifecycle
    
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    //private var currentQuestionIndex: Int = 0
    //private var correctAnswers: Int = 0 //
    
    //private let questionsAmount: Int = 10
    //private var currentQuestion: QuizQuestion?
    //private var questionFactory: QuestionFactoryProtocol? = nil//
    
    private var alertPresenter: AlertPresenterProtocol? = nil//
    
    //private var statisticService: StatisticService? //
    
    private var presenter: MovieQuizPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        //questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        //questionFactory?.loadData()
        //showLoadingIndicator()
        alertPresenter = AlertPresenter(alertController: self)
        //statisticService = StatisticServiceImplementation()
        
        presenter = MovieQuizPresenter(viewController: self)
        
    }
    
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        presenter.didRecieveNextQuestion(question: question)
    
//        guard let question = question else {
//            return
//        }
//
//        currentQuestion = question
//        let viewModel = presenter.convert(model: question)
//        DispatchQueue.main.async { [weak self] in
//            self?.show(quiz: viewModel)
//        }
 //  }
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
//        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
//        guard let currentQuestion = currentQuestion else {
//            return
//        }
//        let givenAnswer = false
//        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
//        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
//        guard let currentQuestion = currentQuestion else {
//            return
//        }
//        let givenAnswer = true
//        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Private functions
    
    func show(quiz step: QuizStepViewModel) {
        
        imageView.layer.borderColor = UIColor.clear.cgColor
        noButton.isEnabled = true
        yesButton.isEnabled = true
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
//    private func convert(model: QuizQuestion) -> QuizStepViewModel {
//        return QuizStepViewModel(
//            image: UIImage(data: model.image) ?? UIImage(),
//            question: model.text,
//            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
//    }
    
//    func showAnswerResult(isCorrect: Bool) {
//        presenter.didAnswer(isCorrectAnswer: isCorrect)
//        
//        imageView.layer.masksToBounds = true
//        imageView.layer.borderWidth = 8
//        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
//        imageView.layer.cornerRadius = 20
//        
//        noButton.isEnabled = false
//        yesButton.isEnabled = false
//        
//        self.presenter.alertPresenter = self.alertPresenter
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
//            guard let self = self else { return }
//            //self.presenter.questionFactory = self.questionFactory
//            //self.presenter.statisticService = self.statisticService
//           
//            self.presenter.showNextQuestionOrResults()
//        }
//    }
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        self.presenter.alertPresenter = self.alertPresenter
    }

    //private func showNextQuestionOrResults() {
        
      
        
//        if presenter.isLastQuestion() {
//            statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
//            guard
//                let bestGame = statisticService?.bestGame,
//                let gamesCount = statisticService?.gamesCount,
//                let totalAccuracy = statisticService?.totalAccuracy
//            else {
//                return
//            }
//            let alertModel = AlertModel(
//                title: "Этот раунд окончен!",
//                message: """
//                        Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
//                        Количество сыгранных квизов: \(gamesCount)
//                        Рекорд: \(bestGame.correct)/\(bestGame.total)/(\(bestGame.date.dateTimeString))
//                        Средняя точность: \(String(format: "%.2f", statisticService!.totalAccuracy))%
//                        """,
//                buttonText: "Сыграть ещё раз") {
//                    self.presenter.resetQuestionIndex()
//                    self.correctAnswers = 0
//                    self.questionFactory?.requestNextQuestion()
//                }
//            alertPresenter?.showAlert(result: alertModel)
//        } else {
//            presenter.switchToNextQuestion()
//            questionFactory?.requestNextQuestion()
//        }
    //}
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: { [weak self]  in
                guard let self = self else {
                    return
                }
                self.presenter.restartGame()
                //self.questionFactory?.requestNextQuestion()
            })
        presenter.alertPresenter?.showAlert(result: alertModel)
    }
    
//    func didLoadDataFromServer() {
//        activityIndicator.isHidden = true
//        questionFactory?.requestNextQuestion()
//    }
//
//    func didFailToLoadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription)
//    }
}

