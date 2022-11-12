import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didecieveNextQuestion(question: QuizQuestion?)
}
