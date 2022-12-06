//
//   AlertPresenter.swift
//  MovieQuiz
//
//  Created by Alexander Farizanov on 04.12.2022.
//

import Foundation
import UIKit

class AlertPresenter {
    
    private var questionFactory: QuestionFactoryProtocol? = nil
    weak var alertController : UIViewController?
    init(alertController: UIViewController?)
    {
        self.alertController = alertController
    }
    
    func show(result : AlertModel) {
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default ) { _ in self.questionFactory?.requestNextQuestion()}
   
        alert.addAction(action)
        
        alertController?.present(alert, animated: true, completion: nil)
        questionFactory?.requestNextQuestion()
        
    }
}
