//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Viktoria Lobanova on 01.12.2022.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var controller: UIViewController?
    
    func show(alert model: AlertModel) {
        // здесь мы показываем результат прохождения квиза
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: model.action)
        
        alert.addAction(action)
        controller?.present(alert, animated: true, completion: nil)
    }
    
    
}


