//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 11.07.2023.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
    
    /// Отображение уведомления о результатах игры
    /// - Parameters:
    ///     - model: AlertModel-структура
    func alert(with model: AlertModel) {
        
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default, handler: model.completion)
        
        alert.addAction(action)
        
        delegate?.present(alert, animated: true)
    }
}
