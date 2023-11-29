//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Malik Timurkaev on 19.11.2023.
//

import UIKit


class AlertPresenter {
    public weak var controller: MovieQuizViewController?
    
    func show2(quiz result: AlertModel) {

        
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            
            result.comletion()
        }
        
        alert.addAction(action)

        self.controller?.present(alert, animated: true)
        //        , completion: nil
    }
    
    
}
