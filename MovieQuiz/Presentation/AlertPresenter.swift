//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Sergey Ivanov on 18.12.2023.
//
//

import UIKit

final class AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
    
    func present(alertModel: AlertModel, on viewController: UIViewController) {
        let alert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { [weak self] _ in
            self?.delegate?.alertDidDismiss()
        }
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}
