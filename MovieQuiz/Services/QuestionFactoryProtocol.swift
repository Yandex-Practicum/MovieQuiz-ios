import UIKit

protocol QuestionFactoryProtocol {
    
    var delegate: QuestionFactoryDelegate? {set get}
    
    func requestNextQuestion()
}
