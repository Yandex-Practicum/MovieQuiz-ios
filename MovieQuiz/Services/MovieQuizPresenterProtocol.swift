import Foundation

protocol MovieQuizPresenterProtocol {
    func yesButtonClicked()
    
    func noButtonClicked()
    
    func makeResultsMessage() -> String
    
    func restartGame()
    
    func switchToNextQuestion()
    
    func createAlertModel(title: String, message: String, buttonText: String, buttonAction: @escaping () -> Void) -> AlertModel
}
