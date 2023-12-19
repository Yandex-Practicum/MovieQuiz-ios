import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didResevedNextQuestion(question: QuizQuestion?)
}
