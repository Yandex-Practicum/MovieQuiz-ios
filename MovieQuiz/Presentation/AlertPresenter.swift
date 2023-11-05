//
//  AlertPresenter.swift
//  MovieQuiz

import Foundation
import UIKit

final class AlertPresenter {
    private weak var controller: UIViewController?
    
    init(controller: UIViewController? = nil) {
        self.controller = controller
    }
        func show(result: AlertModel) {
            let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: result.buttonText, style: .default) {_ in result.completion() }
            alert.addAction(alertAction)
            controller?.present(alert, animated: true)
        }
}
