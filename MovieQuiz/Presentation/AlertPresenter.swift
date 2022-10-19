//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Marina on 17.10.2022.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    let viewController: UIViewController?
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func presentAlert(model: AlertModel) {
        let alertController = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        
        alertController.addAction(action)
        viewController?.present(alertController, animated: true)
    }
}
