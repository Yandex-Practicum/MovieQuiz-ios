//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Артем Чалков on 24.10.2023.
//

import Foundation

import UIKit

class AlertPresenter {
    
    var completion: (()->())?
    
    func showQuizResult(model: AlertModel, controller: UIViewController) {
        
        let alert = UIAlertController(
            title: model.title, //"Раунд окончен!",
            message: model.message, //"Ваш результат: \(count)/10",
            preferredStyle: .alert)
        
        let continueAction = UIAlertAction.init(
            title: model.buttonText, //"Сыграть ещё раз",
            style: .default) { action in
                
                print(action, #line)
                
                self.completion?()
            }
        
        alert.addAction(continueAction)
        controller.present(alert, animated: true)
    }
}
