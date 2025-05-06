//
//  ResultAlertPresenter.swift
//  MovieQuiz
//
//  Created by LERÄ on 03.10.23.
//


import Foundation
import UIKit

protocol AlertPresenter {
    func show(alertModel: AlertModel)
}

final class ResultAlertPresenter: AlertPresenter{
    
    weak var viewController: UIViewController?
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.textButton, style: .default) {  _ in
            alertModel.completion()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}

