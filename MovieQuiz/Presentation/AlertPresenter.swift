//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by ДЖООООН СИНААААА ТА ТА ДА ТААААМ on 20.02.2024.
//

import UIKit

class AlertPresenter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showAlert(with model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}

