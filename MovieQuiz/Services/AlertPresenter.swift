//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 19.07.2023.
//

import Foundation
import UIKit

final class AlertPresenter: AlertProtocol {
    
    func requestAlert(in vc: UIViewController, alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.text,
                                      preferredStyle: .alert)
        alert.view.accessibilityIdentifier = alertModel.alertId
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }
        alert.addAction(action)
        alert.view.accessibilityIdentifier = "Game results"
        
        vc.present(alert, animated: true)
    }
}

