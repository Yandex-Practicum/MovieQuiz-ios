//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Федор Завьялов on 19.11.2023.
//

import UIKit

final class AlertPresenter: UIViewController {
    
    func showAlert(quiz result: AlertModel, controller: MovieQuizViewController){
        
        //Создаем Alert
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "alertId"
        //Создаем действие для Alert
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            
            if let alertAction = result.completion {
                alertAction()
            }
        }
        
        alert.addAction(action)
        
        //Отображаем Alert на главном контроллере
        controller.present(alert, animated: true, completion: nil)
    }
}
