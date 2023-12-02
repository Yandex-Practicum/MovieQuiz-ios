//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Федор Завьялов on 19.11.2023.
//

import UIKit

class AlertPresenter: UIViewController {
    
    func showAlert(quiz result: AlertModel, controller: MovieQuizViewController){
        
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
        controller.present(alert, animated: true, completion: nil)
        
    }
    
//    func networkErrorAlert(model: AlertModel, controller: MovieQuizViewController) {
//        
//        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
//        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
//            //инициализируем повторную загрузку данных
//        }
//        alert.addAction(action)
//        controller.present(alert, animated: true, completion: nil)
//    }
}
