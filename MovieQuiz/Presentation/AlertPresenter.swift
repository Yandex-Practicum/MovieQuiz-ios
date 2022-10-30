//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Alexey Tsidilin on 26.10.2022.
//

import Foundation
import UIKit

struct AlertPresenter {
    
    var viewController: UIViewController?    
    func showAlert(quiz result: AlertModel) {
        
        let alert = UIAlertController(
            title: result.title, // заголовок всплывающего окна
            message: result.message, // текст во всплывающем окне
            preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet
        
        let action = UIAlertAction(
            title: result.buttonText,
            style: .default,
            handler: result.completion
        )

        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }

}

