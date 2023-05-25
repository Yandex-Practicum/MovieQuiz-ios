import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: MovieQuiz.QuizStepViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showResult(present: UIAlertController)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func setInteractionEnabled(_ val: Bool)
}
