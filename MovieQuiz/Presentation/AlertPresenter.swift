//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ina on 20/03/2023.
//

import UIKit

final class AlertPresenter {
    static func present(view controller: UIViewController, alert model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: model.buttontext,
            style: .default,
            handler: model.completion)
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
}
