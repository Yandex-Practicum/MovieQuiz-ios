//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Федор Завьялов on 19.11.2023.
//

import UIKit

class AlertPresenter: UIViewController {
    
    public weak var controller: MovieQuizViewController?
    
    var alert: AlertModel?
    
    func showAlert(quiz result: AlertModel?){
        
        guard let result else { return }
        //Создаем Alert
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
        
        //Создаем действие для Alert
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
        
            if let alertAction = result.completion {
                alertAction()
            }
        }
        
        alert.addAction(action)
            
        //Отображаем Alert на главном контроллере
        if let controller {
            controller.present(alert, animated: true, completion: nil)
        }
        
    }
    
}
