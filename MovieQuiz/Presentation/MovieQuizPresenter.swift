// swiftlint:disable all
import UIKit

final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    private var correctAnswersCounter = 0
    weak var viewController: MovieQuizViewController?
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quiz = QuizStepViewModel(
            image: model.image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return quiz
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func noButtonClicked() {
        processUserAnswer(answer: false)
        print("NO BUTTON TAPED")
    }
    
    func yesButtonClicked() {
        processUserAnswer(answer: true)
        print("YES BUTTON TAPED")
    }
    
    private func processUserAnswer(answer: Bool) {
        
        if let currentQuestion = currentQuestion {
            if answer == currentQuestion.correctAnswer {
                viewController?.showAnswerResult(isCorrect: true)
                correctAnswersCounter += 1
            } else {
                viewController?.showAnswerResult(isCorrect: false)
            }
        }
    }
    
}
