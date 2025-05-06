//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Александр Сироткин on 30.11.2022.
//

import Foundation
import UIKit

final class AlertPresenter {

    func show (model: AlertModel, controller: UIViewController) -> Void {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)

        let action = UIAlertAction(
            title: model.buttonText, style: .default) { [model] _ in
            model.completion()
        }

        alert.addAction(action)

        controller.present(alert, animated: true, completion: nil)
    }

}
