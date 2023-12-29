//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ilya Shirokov on 27.12.2023.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    func showResualtAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText,style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        
        delegate?.showAlert(alert: alert)
    }
}
