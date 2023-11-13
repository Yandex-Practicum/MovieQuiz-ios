//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Sergey Telnov on 25/10/2023.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: UIViewController?
    
    func alertSignal(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.buttonAction()
        }
        alert.addAction(action)
        delegate?.present(alert, animated: true)
    }
}
