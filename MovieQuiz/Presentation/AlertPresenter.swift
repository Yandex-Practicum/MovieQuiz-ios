//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Василий on 11.06.2023.
//

import Foundation
import UIKit

protocol AlertPresenter {
    
    func show(alertModel: AlertModel)
}

final class AlertPresenterProtocol: AlertPresenter {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
}

extension AlertPresenterProtocol {
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)

        let action = UIAlertAction(title: alertModel.buttonText, style: .default) {  [weak self] _ in
            guard let self = self else { return }

            alertModel.buttonAction()
        }

        alert.addAction(action)

        viewController?.present(alert, animated: true)
    }
}
