import Foundation
protocol QuestionFactoryProtocol {
    func requestNextQuestion(completion: (QuizQuestion?) -> Void)
}


