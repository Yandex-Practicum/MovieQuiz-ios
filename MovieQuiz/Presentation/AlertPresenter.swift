//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Рамиль Аглямов on 16.04.2023.
//

import Foundation
import UIKit

final class AlertPresenter: AlertProtocol {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

    func show (alertModel: AlertModel) {
        let alertController = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
          //  buttonText: alertModel.buttonText,
            preferredStyle: .alert)


        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in alertModel.completion!() }

        alertController.addAction(action)

        viewController?.present(alertController, animated: true)

    }

}
