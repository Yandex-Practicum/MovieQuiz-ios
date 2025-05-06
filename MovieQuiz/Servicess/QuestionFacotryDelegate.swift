import Foundation

protocol QuestionFacotryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
