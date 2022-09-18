import UIKit

final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0

    weak var viewController: MovieQuizViewController?
    var currentQuestion: QuizQuestion?
    
    private var counterCorrectAnswers: Int = 0

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
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }

    func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else { return }

        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }

    func noButtonClicked() {
        guard let currentQuestion = currentQuestion else { return }

        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }

}
