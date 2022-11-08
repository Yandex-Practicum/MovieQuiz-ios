//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Konstantin Zuykov on 08.11.2022.
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
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            self.alertModel.completion()
        }
        
        guard let viewController = viewController else { return }
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
