import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    private var correctAnswers: Int = 0
    
    
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion?
    private let questionsCount: Int = 10
    
    private var questionFactory: QuestionFactory?
    private var resultAlertPresenter: ResultAlertPresenter?
    private var statisticService: StatisticService?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactoryImplementation(delegate: self)
        resultAlertPresenter = ResultAlertPresenterImplementation(viewController: self)
        statisticService = StatisticServiceImplementation()
        
        imageView.layer.cornerRadius = 20
        
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - Actions
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion?.correctAnswer)
        yesButton.layer.masksToBounds = true
        yesButton.layer.borderWidth = 4
        yesButton.layer.borderColor = UIColor.ypBackground.cgColor
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        noButton.layer.masksToBounds = true
        noButton.layer.borderWidth = 4
        noButton.layer.borderColor = UIColor.ypBackground.cgColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsCount)")
    }
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        noButton.layer.borderWidth = 0
        yesButton.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
        noButton.layer.borderWidth = 0
        yesButton.layer.borderWidth = 0
        imageView.layer.borderWidth = 0
        if currentQuestionIndex == questionsCount - 1 {
            showFinalResults()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showFinalResults() {
        statisticService?.store(correct: correctAnswers, total: questionsCount)
        
        let alertModel = AlertModel(
            tittle: "Игра окончена!",
            message: makeResultMessage(),
            buttonText: "OK",
            buttonAction: { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
        )
        
        resultAlertPresenter?.show(alertModel: alertModel)
    }
    private func makeResultMessage() -> String {
        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
            assertionFailure("error message")
            return ""
        }
        
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsCount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(accuracy)%"
        
        let components: [String] = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ]
        let resultMessage = components.joined(separator: "\n")
        
        return resultMessage
    }
}

extension MovieQuizViewController: QuestionFactoryDelegate {
    
    func didReceiveQuestion(_ question: QuizQuestion) {
        self.currentQuestion = question
        let viewModel = self.convert(model: question)
        self.show(quiz: viewModel)
    }
}
