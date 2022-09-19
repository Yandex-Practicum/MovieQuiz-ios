import UIKit

final class MovieQuizPresenter {

    // MARK: - Variables
    let questionsAmount: Int = 1
    private var currentQuestionIndex: Int = 0
    private var counterCorrectAnswers: Int = 0
    var correctAnswers: Int = 0

    private var numberOfQuizGames: Int = 0
    private var recordCorrectAnswers: Int = 0
    private var recordDate = Date()
    private var averageAccuracy: Double = 0.0

    private var statisticService: StatisticService = StatisticServiceImpl()
    private var moviesLoader = MoviesLoader()
    private var gameCount: Int = 0

    weak var viewController: MovieQuizViewController?
    var currentQuestion: QuizQuestion?
    var questionFactory: QuestionFactoryProtocol?

    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }

    // MARK: - Buttons
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }

    func noButtonClicked() {
        didAnswer(isYes: false)
    }

    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }

        let givenAnswer = isYes

        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    // MARK: - Functions
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }

    func restartGame() {
        currentQuestionIndex = 0
        counterCorrectAnswers = 0
        questionFactory?.loadData()
    }

    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }

    func showNextQuestionOrResults() {
//        yesAnswerButton.isEnabled = true
//        noAnswerButton.isEnabled = true
        
        if self.isLastQuestion() {
            numberOfQuizGames += 1
            correctAnswers += counterCorrectAnswers
            getResultQuiz()
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }

    func getResultQuiz() {
//        statisticService.store(correct: correctAnswers, total: self.questionsAmount)

        let title = correctAnswers == self.questionsAmount ?
        "Поздравляем, вы ответили на все вопросы верно!" :
        "Вы ответили на \(correctAnswers) из 10, попробуйте еще раз!"

        let resultMessage = makeResultsMessage()

        averageAccuracy = Double(correctAnswers * 100) / Double(self.questionsAmount * numberOfQuizGames)
        let resultQuiz = ResultAlertPresenter(
            title: title,
            message: resultMessage,
            controller: viewController!,
            actionHandler: { [weak self] _ in
                guard let self = self else { return }
                self.restartGame()
            }
        )
        resultQuiz.showResultAlert()
    }

    func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)

        let bestGame = statisticService.bestGame

        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total) \(bestGame.date.dateTimeString)"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", averageAccuracy))%"

        let resultMessage = [currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine].joined(separator: "\n")

        return resultMessage
    }

//    private func restart() {
//        counterCorrectAnswers = 0
//        resetQuestionIndex()
//        questionFactory?.loadData()
//    }
}
