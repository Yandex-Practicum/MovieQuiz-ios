//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Андрей Чупрыненко on 10.07.2023.
//

import Foundation
import UIKit

class AlertPresenter {
    let alertModel: AlertModel
        weak var viewController: UIViewController?
        
        init(alertModel: AlertModel, viewController: UIViewController) {
            self.alertModel = alertModel
            self.viewController = viewController
        }
        
        func showResultsAlert() {
            let alert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
            let action = UIAlertAction(title: alertModel.buttonText, style: .default) { [weak self] _ in
                self?.alertModel.completion()
            }
            
            guard let viewController = viewController else { return }
            alert.addAction(action)
            viewController.present(alert, animated: true, completion: nil)
        }
}
