//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Artem Adiev on 07.12.2022.
//
import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    private weak var controller: UIViewController?
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    
    func showAlert(result: AlertModel) {
        
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: "Сыграть еще раз",
            style: .default,
            handler: { _ in result.completion() }
        )
        
        alert.addAction(action)
        controller?.present(alert, animated: true, completion: nil)
        
    }
    
}

/*

let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
let action = UIAlertAction(title: result.buttonText, style: .default, handler: { _ in
    self.currentQuestionIndex = 0
    self.correctAnswers = 0
    
    self.questionFactory?.requestNextQuestion()
    
})

alert.addAction(action)

self.present(alert, animated: true, completion: nil)

*/
