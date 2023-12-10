import Foundation

protocol QuestionFactoryProtocol{
    func requestNextQuestion()
    var delegate: QuestionFactoryDelegate?{ get set }
} 
