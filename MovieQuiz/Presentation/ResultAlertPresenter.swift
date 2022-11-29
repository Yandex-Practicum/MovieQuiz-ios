//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Григорий Сухотин on 19.11.2022.
//

import Foundation
import UIKit

class ResultAlertPresenter {
    private weak var controller: UIViewController?
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func present(alert: AlertModel, style: UIAlertController.Style) {
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: style)
        let action = UIAlertAction(title: alert.buttonText, style: .default, handler: alert.completion)
        alertController.addAction(action)
        controller?.present(alertController, animated: true)
    }
}
