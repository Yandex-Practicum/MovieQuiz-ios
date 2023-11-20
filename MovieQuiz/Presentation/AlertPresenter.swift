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
        
        //Создаем действие Alert и выводим его на экран
        if let action = result.completion {
            alert.addAction(action())
            
        }
        if let controller {
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
}
