import Foundation

protocol MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel)
    //func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
