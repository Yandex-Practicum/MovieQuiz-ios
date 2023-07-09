//
//  AlertFactory.swift
//  MovieQuiz
//
//  Created by Анастасия Хоревич on 09.07.2023.
//

import Foundation
import UIKit

final class AlertFactory: AlertPresenter {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
                alertModel.completion()
            }
            alert.addAction(action)
        
            viewController?.present(alert, animated: true)
    }
}
