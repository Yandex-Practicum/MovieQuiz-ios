//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Егор Свистушкин on 25.12.2022.
//

import Foundation
import UIKit

class AlertPresenter {
    
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    func show(quiz result: AlertModel) {
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) {_ in
            result.completion()
        }
        alert.addAction(action)
        delegate?.viewController.present(alert, animated: true, completion: nil)
    }
    
}
