
import Foundation
protocol MovieQuizViewControllerProtocol: AnyObject {
    var alertPresenter: AlertPresenter? { get set }
    func show(quiz quizStepViewModel: QuizStepViewModel)
    func highLightImageBorder (isCorrectAnswer: Bool)
    func hideBorder()
    func buttonsEnable(isEnabled: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
        
}
