import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func updateImageBorder()
    func showNetworkError(message: String)
    func showErrorEmptyJson(message: String)
    func showImageError(message: String)

}

final class MovieQuizPresenter: QuestionFactoryDelegate {
    // MARK: - Variables
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var counterCorrectAnswers: Int = 0
    var correctAnswers: Int = 0

    private var numberOfQuizGames: Int = 0
    private var recordCorrectAnswers: Int = 0
    private var recordDate = Date()
    private var averageAccuracy: Double = 0.0
    private var gameCount: Int = 0

    var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService!
    private weak var viewController: MovieQuizViewControllerProtocol?
    var questionFactory: QuestionFactoryProtocol?

    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController

        statisticService = StatisticServiceImpl()

        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }

    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didReceiveEmptyJson(errorMessage errorMessage: String) {
        viewController?.showErrorEmptyJson(message: errorMessage)
    }

    func didFailToLoadData(with error: Error) {
            viewController?.showNetworkError(message: error.localizedDescription)
    }

    func didFailToLoadImage(with error: Error) {
            viewController?.showImageError(message: error.localizedDescription)
    }

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

    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }

    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }

        let givenAnswer = isYes

        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    // MARK: - Functions
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }

    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
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
        let title = correctAnswers == self.questionsAmount ?
        "Поздравляем, вы ответили на все вопросы верно!" :
        "В этот раз не вышло, попробуйте еще раз!"

        let resultMessage = makeResultsMessage()
        let resultQuiz = ResultAlertPresenter(
            title: title,
            message: resultMessage,
            controller: viewController! as! UIViewController,
            actionHandler: { [weak self] _ in
                guard let self = self else { return }
                self.restartGame()
            }
        )
        resultQuiz.showResultAlert()
    }

    func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)

        averageAccuracy = Double(correctAnswers * 100) / Double(questionsAmount * numberOfQuizGames)

        let bestGame = statisticService.bestGame

        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total) \(bestGame.date.dateTimeString)"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", averageAccuracy))%"

        let resultMessage = [currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine].joined(separator: "\n")

        return resultMessage
    }

    func showAnswerResult(isCorrect: Bool) {
        // TODO: - Добавить блокирование кнопок Да/Нет
        didAnswer(isCorrectAnswer: isCorrect)

//        yesAnswerButton.isEnabled = false
//        noAnswerButton.isEnabled = false
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.viewController?.updateImageBorder()
        }
    }
}
