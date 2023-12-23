
import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject{
    func show(quiz step: QuizStepViewModel)
    func highLightTrueAnswer(isCorrect: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func updateButtonStates(buttonsEnabled: Bool)
    func showFinalResults()
    func showActivityIndicator()
    func changeBetweenQuestions ()
}
