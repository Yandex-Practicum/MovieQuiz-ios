//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Aleksandr Eliseev on 30.10.2022.
//

import Foundation
import UIKit

struct AlertPresenter: AlertPresenterProtocol {

    weak var alertDelegate: AlertPresenterDelegate?
    
    init(alertDelegate: AlertPresenterDelegate) {
        self.alertDelegate = alertDelegate
    }
    
    func makeAlertController(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Final Alert"
        
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default,
            handler: alertModel.completion)
        
        alert.addAction(action)
        
        alertDelegate?.alertPresent(alert: alert)
    }
}
