import Foundation

protocol MovieQuizPresenterProtocol {
    func yesButtonClicked()
    
    func noButtonClicked()
    
    func makeResultsMessage() -> String
    
    func restartGame()
    
    func switchToNextQuestion()
    
    func showQuizResultsAlert()
}
