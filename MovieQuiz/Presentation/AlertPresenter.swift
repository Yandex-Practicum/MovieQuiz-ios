//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Toto Tsipun on 08.11.2022.
//
import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func present(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default, handler: { _ in
            model.completion()
        })
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}
