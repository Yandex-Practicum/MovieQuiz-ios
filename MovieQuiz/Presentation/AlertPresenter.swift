//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Алексей on 27.11.2022.
//

import Foundation
import UIKit

struct AlertPresenter: AlertPresenterProtocol {
    
    private weak var controller: UIViewController?
    
    init(controller: UIViewController? = nil) {
        self.controller = controller
    }
    
    
    func show(quiz result: AlertModel) {
        guard let controller = controller else {return}
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Game Results"
        let action = UIAlertAction(title: result.buttonText, style: .default) {_ in 
            result.completion()
        }
        
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
}
