//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 03.08.2023.
//
import UIKit
class AlertPresenter {
    private weak var presentingViewController: UIViewController?
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    func presentAlert(with model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText,
                                   style: .default) { _ in
            model.completion?()
        }
        alert.addAction(action)
        if let accessibilityIdentifier = model.accessibilityIdentifier {
            alert.view.accessibilityIdentifier = accessibilityIdentifier
        }
        presentingViewController?.present(alert, animated: true, completion: nil)
    }
}
