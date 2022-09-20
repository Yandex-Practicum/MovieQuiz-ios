import Foundation

protocol QuestionFactoryDelegate {
    func didRequestNextQuestion()
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
