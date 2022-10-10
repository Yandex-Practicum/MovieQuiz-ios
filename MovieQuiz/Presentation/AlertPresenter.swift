//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Andrey Sysoev on 29.09.2022.
//

import Foundation
import UIKit

struct AlertPresenter {
    weak var controller: UIViewController?
    
    func showAlert(with content: AlertModel) {
        let alert = UIAlertController(
            title: content.title,
            message: content.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: content.buttonText, style: .cancel) { _ in
            content.completion()
        }

        alert.addAction(action)

        controller?.present(alert, animated: true, completion: nil)
    }
}
