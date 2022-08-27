import Foundation
protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizeQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
