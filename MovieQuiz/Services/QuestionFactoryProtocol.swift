//
// Протокол для доступа к методу вызова следующего вопроса из фабрики
//

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func loadData()
}
