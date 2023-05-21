//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Admin on 20.05.2023.
//

import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func show(with model: AlertModel)
}

class AlertPresenter: AlertPresenterProtocol {
    private weak var viewController: UIViewController?
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    func show(with model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    
    
}
