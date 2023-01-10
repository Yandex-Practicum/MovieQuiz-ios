//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Андрей Парамонов on 11.01.2023.
//

import UIKit

final class AlertPresenter {
    private let controller: UIViewController

    init(controller: UIViewController) {
        self.controller = controller
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
        controller.present(alert, animated: true, completion: nil)
    }
}
