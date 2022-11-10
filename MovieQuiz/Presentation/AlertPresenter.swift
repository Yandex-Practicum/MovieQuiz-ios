//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Respect on 10.11.2022.
//

import Foundation
import UIKit


struct AlertPresenter {
    
    weak var viewController: UIViewController?
    func showAlert(quiz result: AlertModel) {
        
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: result.buttonText,
            style: .default,
            handler: result.completion)

        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
