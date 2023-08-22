import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate  {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    
    private var questionFactory: QuestionFactoryProtocol?
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
        
    }
    
    // MARK: - Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 8
        noButton.layer.cornerRadius = 15
        yesButton.layer.cornerRadius = 15
        showNextQuestionOrResults()
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        showLoadingIndicator()
        questionFactory?.loadData()
        
    }
    
    // MARK: - Public Methods
    
    func didReciveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
        activityIndicator.isHidden = true // скрываем индикатор загрузки
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    
    // MARK: - IBAction
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = false
        currentQuestionIndex += 1
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        currentQuestionIndex += 1
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    // MARK: - Private Methods
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount {
            showFinalResults()
        } else {
            questionFactory?.requestNextQuestion()
            
        }
        yesButton.isEnabled = true
        noButton.isEnabled = true
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
        hideLoadingIndicator() // скрываем индикатор загрузки
        let alert : AlertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.loadData()
                
            }
        alertPresenter?.showAlert(alert)
    }
    
    private func showFinalResults() {
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: makeResultMessage(),
            buttonText: "Сыграть ещё раз",
            completion: { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
        )
        alertPresenter?.showAlert(alertModel)
    }
    
    private func makeResultMessage() -> String {
        
        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
            assertionFailure("error message")
            return ""
        }
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%2.f", statisticService.totalAccuracy))%"
        let components: [String] = [currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine]
        let resultMessage = components.joined(separator: "\n")
        return resultMessage
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        // MARK: - Delay
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
        }
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    

    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(data: model.image) ?? UIImage()
        let questionText = model.text
        let number = "\(currentQuestionIndex+1)/\(questionsAmount)"
        
        return QuizStepViewModel(image: image, question: questionText, questionNumber: number)
    }
}



