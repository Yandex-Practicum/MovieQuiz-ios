protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion)
    func didLoadDataFromServer()
    func didFailToLoadDataFromServer(with error: Errors)
    func didFailToLoadImageFromServer(with error: Errors)
}
