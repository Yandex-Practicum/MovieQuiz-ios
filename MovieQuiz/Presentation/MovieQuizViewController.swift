import UIKit

// MARK: - MovieQuizViewController Class

final class MovieQuizViewController: UIViewController{
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet private weak var counerLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var correctAnswers: Int = 0
    
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticService = StatisticServiceImplementation()
    
    /// Фабрика уведомлений
    internal var alertPresenter: AlertPresenterProtocol?
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        activityIndicator.hidesWhenStopped = true
        showLoadingIndicator(is: true)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        toggleButtons(to: false)
        guard let currentQuestion = currentQuestion else { return }
        
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        toggleButtons(to: false)
        guard let currentQuestion = currentQuestion else { return }
        
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
    
    private func convert(question: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: question.image) ?? UIImage(),
            question: question.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func show(quizStep model: QuizStepViewModel){
        imageView.image = model.image
        textLabel.text = model.question
        counerLabel.text = model.questionNumber
        imageView.layer.borderColor = UIColor.clear.cgColor
        toggleButtons(to: true)
        showLoadingIndicator(is: true)
    }
    
    private func toggleButtons(to state: Bool){
        noButton.isEnabled = state
        yesButton.isEnabled = state
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        showLoadingIndicator(is: false)
        
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let totalQuestions = currentQuestionIndex + 1
            statisticService.store(correct: correctAnswers, total: totalQuestions)
            let bestGame = statisticService.bestGame
            let text = """
                            Ваш результат: \(correctAnswers)/\(totalQuestions)
                            Количество сыгранных квизов: \(statisticService.gamesCount)
                            Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
                            Средняя точность: \(String(format: "%.2f", statisticService.accuracy))%
                        """
            let alertModel = AlertModel(title: "Этот раунд окончен!", message: text, buttonText: "Сыграть ещё раз", completion: startNewQuiz)
            
            alertPresenter?.alert(with: alertModel)
            
        } else {
            currentQuestionIndex += 1
            
            questionFactory?.requestNextQuestion()
        }
    }
    
    internal func showLoadingIndicator(is displayed: Bool){
        if displayed {
            activityIndicator.startAnimating()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    private func showNetworkError(message: String){
        showLoadingIndicator(is: false)
        let messageText = message.isEmpty ? "При загрузке данных возникла ошибка" : message
        
        let alertModel = AlertModel(title: "Ошибка", message: messageText, buttonText: "Попробовать ещё раз" ) { [weak self] _ in
            
            self?.questionFactory?.loadData()
        }
        alertPresenter?.alert(with: alertModel)
    }
}


// MARK: - QuestionFactoryDelegate

extension MovieQuizViewController: QuestionFactoryDelegate {
    
    internal func didReceiveNextQuestion(question: QuizQuestion?){
        guard let question  = question else { return }
        
        currentQuestion = question
        
        let viewModel = convert(question: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quizStep: viewModel)
        }
    }
    
    func didLoadDataFromServer(){
        showLoadingIndicator(is: false)
        questionFactory?.requestNextQuestion()
    }
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}

// MARK: - AlertPresenterDelegate
extension MovieQuizViewController: AlertPresenterDelegate {
    
    /// Функция для инициализации квиз-раунда
    internal func startNewQuiz( _ : UIAlertAction){
        
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        self.questionFactory?.requestNextQuestion()
    }
}


