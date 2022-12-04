import Foundation

protocol QuestionFactoryDelegate: class {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
