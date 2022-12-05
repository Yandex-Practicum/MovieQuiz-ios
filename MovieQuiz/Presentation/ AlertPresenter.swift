//
//   AlertPresenter.swift
//  MovieQuiz
//
//  Created by Alexander Farizanov on 04.12.2022.
//

import Foundation
import UIKit

class AlertPresenter: QuestionFactoryDelegate {
    func didRecieveNextQuestion(question: QuizQuestion?) {
    
    }
    
    private var questionFactory: QuestionFactoryProtocol? = nil
    //questionFactory = QuestionFactory(delegate: self)
    var alertController : UIViewController?
    init(alertController: UIViewController? = nil) {self.alertController = alertController}
    
     func show(result : AlertModel) {
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
         let action = UIAlertAction(title: result.buttonText, style: .default)
        alert.addAction(action)
        alertController?.present(alert, animated: true, completion: nil)
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
    }
}
