//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Maxim Rustamov on 7.01.2023.
//

import UIKit

struct AlertPresenter {
    weak var controller: UIViewController?
    func show(alert model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: model.completion)
           
           alert.addAction(action)
           controller?.present(alert, animated: true, completion: nil)
       }
}
