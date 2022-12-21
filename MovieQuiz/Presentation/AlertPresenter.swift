//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Мария Авдеева on 06.12.2022.
//
import UIKit
import Foundation

struct AlertPresenter {
     func present(alert: AlertModel, presentingViewController: UIViewController) {
         let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        
         let action = UIAlertAction(title: alert.buttonText, style: .default, handler: { _ in alert.completion() })
        
        alertController.addAction(action)
        presentingViewController.present(alertController, animated: true, completion: nil)
    }
}
