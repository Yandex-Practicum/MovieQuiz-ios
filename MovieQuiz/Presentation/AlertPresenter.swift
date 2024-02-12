//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Дмитрий on 10.02.2024.
//

import UIKit

class AlertPresenter {
    
    weak var delegate: AlertDelegate?
    
    func showAlert(alertData: AlertModel) {
        let alert = UIAlertController(title: alertData.title,
                                      message: alertData.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertData.buttonText, 
                                   style: .default,
                                   handler: alertData.completion)
        
        alert.addAction(action)
        
        delegate?.present(alert, animated: true,completion:  nil)
    }
    
}
