import Foundation

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    func didReceiveEmptyJson(errorMessage: String)
    func didFailToLoadImage(with error: Error)
}
