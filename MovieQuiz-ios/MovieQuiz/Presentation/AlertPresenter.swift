//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Maxim Rustamov on 7.01.2023.
//

import UIKit

struct AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
    
    func present(alert: AlertModel) {
        
        let alertController = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: alert.buttonText,
            style: .default,
            handler: alert.completion)
        alertController.addAction(action)
        delegate?.didPresentAlert(alert: alertController)
    }
}
