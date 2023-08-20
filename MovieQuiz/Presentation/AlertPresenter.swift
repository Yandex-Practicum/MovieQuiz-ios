//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Yuriy Varvenskiy on 17.08.2023.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(_ model: AlertModel)
}

class AlertPresenter: AlertPresenterProtocol {
    
    private weak var viewController: UIViewController?
    
    init(delegate: UIViewController?) {
        self.viewController = delegate
    }
    
    func showAlert(_ model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default) { _ in
                model.completion()
            }
        
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}
