import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    // MARK: - Lifecycle
        
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertModel: AlertModel?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticsService: StatisticServiceProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        statisticsService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
    }

    // MARK: - QuestionFactoryDelegate

    internal func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - AlertPresenterDelegate
    
    internal func alertPresent(alert: UIAlertController?) {
        guard let alert = alert else {
            return
        }
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Private functions
    
    private func showFinalAlert() {
        
        let text = "Ваш результат: \(correctAnswers)/\(questionsAmount)\nКоличество сыгранных квизов: \(String(describing: statisticsService!.gamesCount))\nРекорд: \(String(describing: statisticsService!.bestGame.correct))/\(String(describing: statisticsService!.bestGame.total)) (\(String(describing: statisticsService!.bestGame.date.dateTimeString)))\nСредняя точность: \(String(format: "%.2f", statisticsService!.totalAccuracy))%"
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: text,
            buttonText: "Сыграть ещё раз") { [weak self] _ in
                self?.currentQuestionIndex = 0
                self?.questionFactory?.requestNextQuestion()
                self?.correctAnswers = 0
            }
        alertPresenter = AlertPresenter(alertDelegate: self)
        alertPresenter?.makeAlertController(alertModel: alertModel)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let answer = false
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let answer = true
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = currentQuestion?.text
        counterLabel.text = "\(currentQuestionIndex+1)/\(questionsAmount)"
        imageView.image = UIImage(named: currentQuestion?.image ?? "ERROR, check func show")
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1) / \(questionsAmount)")
}
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen?.cgColor;
            correctAnswers += 1 }
        else {
            imageView.layer.borderColor = UIColor.ypRed?.cgColor }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticsService?.store(correct: correctAnswers, total: questionsAmount)
            showFinalAlert()
            
          } else {
            currentQuestionIndex += 1
              questionFactory?.requestNextQuestion()
          }
    }  
}
