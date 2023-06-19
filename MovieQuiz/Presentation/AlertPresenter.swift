//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 13.06.23.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol {
    func showAlert(_ model: AlertModel)
}

final class AlertPresenter: AlertPresenterProtocol {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func showAlert(_ model: AlertModel) {
        let alertController = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in model.completion()
            
        }
        
        alertController.addAction(action)
        
        viewController?.present(alertController, animated: true)
        
    }
}

