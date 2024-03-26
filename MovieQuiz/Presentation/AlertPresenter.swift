//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Yerman Ibragimuly on 28.02.2024.
//
import UIKit
import Foundation

class AlertPresenter: AlertProtocol {
    private weak var delegate: UIViewController?
    init(viewController: UIViewController? = nil) {
        self.delegate = viewController
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
        delegate?.present(alert, animated: true)
    }
}
