import Foundation

protocol QuestionFactoryDelegate: class {                   // 1
    func didRecieveNextQuestion(question: QuizQuestion?)   // 2
}
