//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Даниил Романов on 04.03.2024.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    weak var viewController: UIViewController?
    
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }
        
        alert.addAction(action)
        
        viewController?.present(alert, animated: true)
    }
    
}
