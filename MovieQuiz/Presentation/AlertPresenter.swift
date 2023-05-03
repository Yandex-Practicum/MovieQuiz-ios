//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Sergey Popkov on 20.04.2023.
//

import Foundation
import UIKit

protocol AlertPresenter {
    
    func show(alertModel: AlertModel)
}

final class AlertPresenterImpl: AlertPresenter {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    
    func show(alertModel: AlertModel) {
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
           
            alertModel.action()
        }
        
        alert.addAction(action)
        
        viewController?.present(alert, animated: true)
    }
    
    
}
