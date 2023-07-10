import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let result = currentQuestion.correctAnswer == true
        showAnswerResult(isCorrect: result)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let result = currentQuestion.correctAnswer == false
        showAnswerResult(isCorrect: result)
    }
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    private var currentQuestion: QuizQuestion?
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
             return .lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20.0

        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(),delegate: self)
        alertPresenter = AlertFactory(viewController: self)
        statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.image = step.image
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        imageWithBorder(result: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            showNextQuestionOrResults()
        }
    }
    
    private func renderQuestion(){
        imageView.layer.borderWidth = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func imageWithBorder(result: Bool) {
        if (result) {
            correctAnswers += 1
        }
        let color: UIColor = result ? .ypGreen : .ypRed
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = color.cgColor
        imageView.layer.cornerRadius = 20.0
        imageView.layer.borderWidth = 8
    }
    
    private func showNextQuestionOrResults() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
        
        if currentQuestionIndex == questionsAmount - 1 {
            
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            
            let statistics = statisticService!
            let bestGame = statistics.bestGame
            
            let result = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
            let quizes = "Количество сыгранных квизов: \(String(statistics.gamesCount))"
            let record = "Рекорд: \(bestGame.correct)/\(bestGame.total) \(bestGame.date.dateTimeString)"
            let accuracy = "Средняя точность: \(String(format: "%.2f", statistics.totalAccuracy))%"
            
            let alertMessage = [result,quizes,record,accuracy].joined(separator: "\n")
            
            let quizResultsViewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: alertMessage, buttonText: "Сыграть еще раз")
            show(quiz: quizResultsViewModel)
        } else {
            currentQuestionIndex += 1
            renderQuestion()
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: {
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
        
                self.renderQuestion()
            })
        
        alertPresenter?.show(alertModel: alertModel)
    }
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
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
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
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
        
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз",
            completion: {
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
        
                self.renderQuestion()
            })
        
        alertPresenter?.show(alertModel: alertModel)
    }
    
}



