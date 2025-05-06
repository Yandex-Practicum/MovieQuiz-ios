import UIKit

class MovieQuizViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var questionFactory: QuestionFactory?
    private var currentQuestion: QuizQuestion?
    private let questionsCount = 10
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    private func show(quiz step: QuizStepViewModel) {
      imageView.layer.borderColor = UIColor.clear.cgColor
      imageView.image = step.image
      textLabel.text = step.question
      counterLabel.text = step.questionNumber
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactoryImpl(delegate: self)
        alertPresenter = AlertPresenterImpl(viewController: self)
        statisticService = StatisticServiceImpl()
        questionFactory?.requestNextQuestion()
        imageView.layer.cornerRadius = 8.0
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let givenAnswer = false // 2
        showAnswerResult(isCorrect: givenAnswer == currentQuestion?.correctAnswer) // 3
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let givenAnswer = true // 2
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion?.correctAnswer) // 3
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel( // 1
            image: UIImage(named: model.image) ?? UIImage(), // 2
            question: model.text, // 3
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsCount)") // 4
        return questionStep
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
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
            title: " Игра окончена ",
            message: makeResultMassage(),
            buttonText: "OK",
            buttonAction: { [ weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
        )
        alertPresenter?.show(alertModel: alertModel)
    }
    
    private func makeResultMassage() -> String {
        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
            assertionFailure("error message")
            return " "
        }
    let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
    let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
    let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsCount)"
    let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
    + " (\(bestGame.date.dateTimeString))"
    let averageAccuracyLine = " Средняя точность: \(accuracy))%"
    let components: [ String ] = [ currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine]
    let resultMasage = components.joined(separator: "\n")
        return resultMasage
    }
}
extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveQuestion(_ question: QuizQuestion) {
        self.currentQuestion = question
        let viewModel = self.convert(model: question)
        self.show(quiz: viewModel)
    }
}

