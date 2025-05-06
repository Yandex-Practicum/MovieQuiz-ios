import UIKit

weak var delegate: QuestionFactoryDelegate?

protocol QuestionFactoryDelegate: AnyObject { 
    func didReceiveNextQuestion(question: QuizQuestion?)
}
