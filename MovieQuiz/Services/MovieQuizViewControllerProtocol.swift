import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showQuizResults(model alert: AlertModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func enableButtons()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}

