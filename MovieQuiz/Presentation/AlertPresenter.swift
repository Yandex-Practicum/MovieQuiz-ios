//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ярослав Калмыков on 17.12.2023.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    func createAlert(alertModel: AlertModel?) {
        guard let alertModel = alertModel else { return }
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default,
            handler: { _ in
                alertModel.completion?()})
        
        alert.addAction(action)
        delegate?.showAlert(alert: alert)
    }
}
