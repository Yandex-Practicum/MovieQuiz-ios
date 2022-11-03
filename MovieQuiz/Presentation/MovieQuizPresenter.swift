import Foundation
import UIKit

final class MovieQuizPresenter {
    private var currentQuestionIndex = 0
    let questionAmount = 10
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)")
        
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func answerIs(answer: Bool) {
        viewController?.showAnswerResult(isCorrect: answer == currentQuestion?.correctAnswer)
    }
    
    func yesButtonClicked() {
        answerIs(answer: true)
    }
    
    func noButtonClicked() {
        answerIs(answer: false)
    }
}
