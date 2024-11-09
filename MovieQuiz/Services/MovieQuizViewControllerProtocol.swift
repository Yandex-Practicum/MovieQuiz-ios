

protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func show(quiz step: QuizStepViewModel)
    func showResult(quiz result: AlertModel)
    func highlightImageBorder(isCorrect: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func alertPresenterDidPresent()
}


