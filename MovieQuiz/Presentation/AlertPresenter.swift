//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by admin on 02.01.2024.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    func show(alertModel: AlertModel) {
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default,
            handler: { _ in
                alertModel.buttonAction?()
            }
        )
        
        alert.addAction(action)
        
        delegate?.showAlert(alert: alert)
    }
    
}
