import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate  {
   
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        let presenter = MovieQuizPresenter()
       // noButton.isEnabled = false
        //yesButton.isEnabled = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
       // guard let currentQuestion = currentQuestion else {
          //  return
      //  }
      //  let givenAnswer = true
        //yesButton.isEnabled = false
        //noButton.isEnabled = false
      //  showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        presenter.currentQuestion = currentQuestion
                presenter.yesButtonClicked()
    }
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!

    @IBOutlet private var noButton: UIButton!
    
    @IBOutlet private var yesButton: UIButton!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    //private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenterImpl: AlertPresenter?
    private var statisticService: StatisticService?
    private let presenter = MovieQuizPresenter()
    
    //private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.layer.borderWidth = 0
        //yesButton.isEnabled = true
       // noButton.isEnabled = true
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
        let alertModel = AlertModel (
        title: "Игра окончена",
        message: makeResultMessage(),
        buttonText: "ОК",
        completion: { [weak self] in
            self?.presenter.currentQuestionIndex = 0
            self?.correctAnswers = 0
            self?.questionFactory?.requestNextQuestion()
        }
        )
        alertPresenterImpl?.show(alertModel: alertModel)
    }
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        } 
    }
    private func showNextQuestionOrResults() {
        if presenter.currentQuestionIndex == presenter.questionsAmount - 1 {
            let text = makeResultMessage()
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            presenter.currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
        }
    }
    private func makeResultMessage() -> String {
            guard let statisticService, let bestGame = statisticService.bestGame else {
                return ""
            }
            
            let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)"
            let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
            let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            let resultMessage = [totalPlaysCountLine, currentGameResultLine, bestGameInfoLine, averageAccuracyLine].joined(separator: "\n")
            
            return resultMessage
        }
//    private func convert(model: QuizQuestion) -> QuizStepViewModel {
//        return QuizStepViewModel(
//            image: UIImage(data: model.image) ?? UIImage(),
//            question: model.text,
//            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
//        questionFactory = QuestionFactory(delegate: self)
        alertPresenterImpl = AlertPresenterImpl(viewController: self)
        statisticService = StatisticServiceImplementation()
//        questionFactory?.requestNextQuestion()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
           statisticService = StatisticServiceImplementation()

           showLoadingIndicator()
           questionFactory?.loadData()
        presenter.viewController = self
    }
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenterImpl?.show(alertModel: model)
    }
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}

