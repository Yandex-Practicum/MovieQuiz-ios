import UIKit

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
