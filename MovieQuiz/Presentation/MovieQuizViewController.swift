import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent}
    
    
    // MARK: - Lifecycle
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    private var correctAnswers = 0
    private let questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var numberOfGame = 0
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
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

    //MARK: - Private functions
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: { [weak self] in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.imageView.layer.borderWidth = 0
            self.numberOfGame += 1
            self.questionFactory?.requestNextQuestion()
        })
        alertPresenter?.showAlert(model: alertModel)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        noButton.isEnabled = false
        yesButton.isEnabled = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }
    
    func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            
            guard let statisticService = statisticService else { return }
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let bestGame = statisticService.bestGame
            let recordGame = "\(bestGame.correct)/\(bestGame.total)"
            let currentDate = bestGame.date.dateTimeString
            let roundingTotalAccuracy = String(format: "%.2f", statisticService.totalAccuracy) + "%"
            let text = """
                    Ваш результат: \(correctAnswers)/\(questionsAmount)
                    Кол-во сыгранных квизов: \(statisticService.gamesCount)
                    Рекорд: \(recordGame) (\(currentDate))
                    Средняя точность: \(roundingTotalAccuracy)
                    """
            let vieModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Cыграть ещё раз!")
            show(quiz: vieModel)
        } else {
            imageView.layer.borderWidth = 0
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let givenAnswer = true
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let givenAnswer = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
}










