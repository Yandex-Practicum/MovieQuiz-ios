//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Леонид Турко on 21.01.2023.
//


import UIKit

class AlertPresenter {
    weak var viewController: UIViewController?
    
    func showAlert(model: AlertModel) {
        let alertController = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default) { _ in
                model.completion?()
            }
        alertController.addAction(action)
        viewController?.present(alertController, animated: true)
    }
}
