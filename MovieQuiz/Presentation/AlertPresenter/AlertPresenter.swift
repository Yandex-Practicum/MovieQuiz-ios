//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Viktoria Lobanova on 01.12.2022.
//


import UIKit

final class AlertPresenter: AlertPresenterProtocol {
        
    weak var controller: UIViewController?
    
    func show(alert model: AlertModel, identifier: String) {
        // здесь мы показываем результат прохождения квиза
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: model.action)
        
        alert.addAction(action)
        alert.view.accessibilityIdentifier = identifier
        
        controller?.present(alert, animated: true, completion: nil)
    }
    
    
}


