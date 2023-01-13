//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Андрей Парамонов on 11.01.2023.
//

import UIKit

final class AlertPresenter {
    func show(with model: AlertModel, in view: UIViewController) {
        let alert = UIAlertController(
                title: model.title,
                message: model.message,
                preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        view.present(alert, animated: true, completion: nil)
    }
}
