//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Admin on 20.05.2023.
//

import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func show(with alertModel: AlertModel)
}

final class AlertPresenterImpl {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }

}

extension AlertPresenterImpl: AlertPresenterProtocol {
    func show(with alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default) { _ in
            alertModel.completion()
        }
        alert.addAction(action)
        viewController?.present(alert,
                                animated: true)
    }
}
