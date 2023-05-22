import Foundation

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizeQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    func didFailToLoadImage(with error: Error)
    func didReceiveErrorMessageInJSON(errorMessage: String)
    func didReceiveErrorMessage(errorMessage: String)
}
