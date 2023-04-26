//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Aleksey Shaposhnikov on 24.04.2023.
//

import Foundation
import UIKit

class AlertPresenter: AlertProtocol {
    private weak var controller: UIViewController?

    init(controller: UIViewController) {
        self.controller = controller
    }

    func showAlert(alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) {  _ in
            alertModel.action()
        }

        alert.addAction(action)
        controller?.present(alert, animated: true, completion: nil)
    }
}
