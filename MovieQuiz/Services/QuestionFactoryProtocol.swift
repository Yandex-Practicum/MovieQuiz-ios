import Foundation

protocol QuestionFactoryProtocol: AnyObject {
    func requestNextQuestion()
    var delegate: (QuestionFactoryDelegate)? { get set }
}


