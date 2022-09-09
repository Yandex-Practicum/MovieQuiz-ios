import Foundation

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion)
}
