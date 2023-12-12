import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate  {
    // MARK: - IBOutlet
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var yesButton: UIButton!
    
    // MARK: - IB Actions
    @IBAction private func yesButtonPressed(_ sender: Any) {
        self.updateButtonStates(buttonsEnabled: false)
        guard let currentQuestion = currentQuestion else {
            self.updateButtonStates(buttonsEnabled: true)
            return
        }

        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.updateButtonStates(buttonsEnabled: true)
        }
    }
    
    @IBAction private func noButtonPressed(_ sender: Any) {
        self.updateButtonStates(buttonsEnabled: false)
        guard let currentQuestion = currentQuestion else {
            self.updateButtonStates(buttonsEnabled: true)
            return
        }

        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.updateButtonStates(buttonsEnabled: true)
        }
    }
    
    // MARK: - Private Properties
    private lazy var questionFactory: QuestionFactoryProtocol = {
        let factory = QuestionFactory(moviesLoader:  MoviesLoader(), delegate: self)
        factory.delegate = self
        return factory
    }()
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var alertPresenter: AlertPresenter?
    private var statisticSetvice: StatisticServiceImpl?
    
    // MARK: - Lifecycle
    override final func viewDidLoad() {
        super.viewDidLoad()
        customizationUI()
        alertPresenter = AlertPresenterImpl(viewController:self)
        statisticSetvice = StatisticServiceImpl()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
         loadMovies()
    }
    
    // MARK: - Public Methods
    func didReceiveNextQuestion(question: QuizQuestion?) {
         guard let question = question else {
             return
         }
         currentQuestion = question
         let viewModel = convert(model: question)
         DispatchQueue.main.async { [weak self] in
             self?.show(quiz: viewModel)
             self?.hideLoadingIndicator()
         }
     }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didFailNextQuestion(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - Private functions
    private func customizationUI(){
        view.backgroundColor = UIColor.ypBlack
        
        activityIndicator.color = UIColor.ypBlack
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        
        noButton.setTitle("Нет", for: .normal)
        noButton.setTitleColor(UIColor.ypBlack, for: .normal)
        noButton.backgroundColor = UIColor.ypWhite
        noButton.layer.cornerRadius = 15
        noButton.frame.size = CGSize(width: 157, height: 60)
        
        yesButton.setTitle("Да", for: .normal)
        yesButton.setTitleColor(UIColor.ypBlack, for: .normal)
        yesButton.backgroundColor = UIColor.ypWhite
        yesButton.layer.cornerRadius = 15
        yesButton.frame.size = CGSize(width: 157, height: 60)
        
        textLabel.text = "Вопрос:"
        textLabel.textColor = UIColor.ypWhite
        textLabel.frame.size = CGSize(width: 72, height: 24)
        
        
        counterLabel.textColor = UIColor.ypWhite
        counterLabel.frame.size = CGSize(width: 72, height: 24)
        questionLabel.textColor = UIColor.ypWhite
        questionLabel.frame.size = CGSize(width: 72, height: 24)
        
        imageView.layer.cornerRadius = 20
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect { // 1
            correctAnswers += 1 // 2
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            showFinalResults()
            imageView.layer.borderColor = UIColor.clear.cgColor
        } else {
            activityIndicator.color = UIColor.white
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            currentQuestionIndex += 1
            self.questionFactory.requestNextQuestion()
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func showFinalResults(){
        statisticSetvice?.store(correct: correctAnswers, total: questionsAmount)
        let alertModel = AlertModel(
            title: "Игра окончена!",
            message: makeResultMessage(),
            buttonText: "OK",
            buttonAction: {[weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory.requestNextQuestion()
            }
        )
        alertPresenter?.show(alertModel: alertModel)
    }
    
    private func makeResultMessage() -> String {
        guard let statisticService = statisticSetvice, let bestGame = statisticSetvice?.bestGame else{
            assertionFailure("Error")
            return ""
        }
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let totalPlaysCount = "Количество сыгранных квизов:\(statisticService.gamesCount)"
        let currentGameResult = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfo = "Рекорд: \(bestGame.correct)\\\(bestGame.total)" +
        " (\(bestGame.date.dateTimeString))"
        let averageAccuracy = "Средняя точность: \(accuracy)%"
        let resultMessage = [
            currentGameResult, totalPlaysCount, bestGameInfo, averageAccuracy
        ].joined(separator: "\n")
        return resultMessage
    }

    private func showLoadingIndicator() {
        activityIndicator.isHidden = false //
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func hideLoadingIndicator(){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory.requestNextQuestion()
        }
        
        alertPresenter?.show(alertModel: model)
    }
    
    private func loadMovies(){
        showLoadingIndicator()
        questionFactory.loadData()
    }
    
    private func updateButtonStates(buttonsEnabled: Bool) {
        yesButton.isEnabled = buttonsEnabled
        noButton.isEnabled = buttonsEnabled
    }
}

