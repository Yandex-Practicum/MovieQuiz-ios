//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Влад on 12.01.2023.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    private weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in model.completion()
        }
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
