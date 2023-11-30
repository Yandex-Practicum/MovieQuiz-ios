import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showFinalResults()
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    func noImageBorder()
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func enebleButtons()
    func disableButtons()
    
    func showNetworkError(message: String)
}
