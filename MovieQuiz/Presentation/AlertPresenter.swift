//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Mir on 26.03.2023.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func showAlert(model: AlertModel) {
        
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText,
                                   style: .default) { [weak self] _ in
            model.completion?()
            self?.delegate?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
