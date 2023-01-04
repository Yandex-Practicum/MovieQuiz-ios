import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    var correctAnswers: Int = 0 //
    var questionFactory: QuestionFactoryProtocol? = nil//
    var alertPresenter: AlertPresenterProtocol? = nil//
    var statisticService: StatisticService? //
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
//    func yesButtonClicked(_ sender: Any) {
//        guard let currentQuestion = currentQuestion else {
//            return
//        }
//        let givenAnswer = true
//        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
//    }
//    func noButtonClicked(_ sender: Any) {
//        guard let currentQuestion = currentQuestion else {
//            return
//        }
//        let givenAnswer = false
//        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
//    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard  let question = question else {
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
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            guard
                let bestGame = statisticService?.bestGame,
                let gamesCount = statisticService?.gamesCount,
                let totalAccuracy = statisticService?.totalAccuracy
            else {
                return
            }
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: """
                        Ваш результат: \(self.correctAnswers)/\(questionsAmount)
                        Количество сыгранных квизов: \(gamesCount)
                        Рекорд: \(bestGame.correct)/\(bestGame.total)/(\(bestGame.date.dateTimeString))
                        Средняя точность: \(String(format: "%.2f", statisticService!.totalAccuracy))%
                        """,
                buttonText: "Сыграть ещё раз") {
                    self.resetQuestionIndex()
                    self.correctAnswers = 0
                    self.questionFactory?.requestNextQuestion()
                }
            alertPresenter?.showAlert(result: alertModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
}
