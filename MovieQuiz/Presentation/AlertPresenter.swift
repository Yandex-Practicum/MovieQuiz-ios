//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Владимир Клевцов on 17.5.23..
//

import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func show(with model: AlertModel)
}
class AlertPresenter: AlertPresenterProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController){
        self.viewController = viewController
    }
    func show(with model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Alert"
        let ation = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.comletion()
        }
        
        alert.addAction(ation)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
