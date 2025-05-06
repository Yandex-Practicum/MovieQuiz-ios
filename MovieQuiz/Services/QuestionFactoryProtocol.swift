import Foundation

protocol QuestionFactoryProtocol: AnyObject {
    var delegate: QuestionFacotryDelegate? { get set }
    func requestNextQuestion()
    func loadData()
}
