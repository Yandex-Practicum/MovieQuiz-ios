//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Olga Vasileva on 18.06.2023.
//

import Foundation
import UIKit

protocol AlertPresenter {
    
    func show(alertModel: AlertModel)
}

final class AlertPresenteImpl{
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    
    
}

extension AlertPresenteImpl: AlertPresenter {
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.actionButton()
            
        }

        alert.addAction(action)
        
        viewController?.present(alert, animated: true)
        

    }
}
