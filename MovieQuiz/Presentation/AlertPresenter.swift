//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Дмитрий Редька on 27.11.2022.
//

import UIKit
struct AlertPresenter {

    weak var delegate: AlertPresenterDelegate?
    
    func showResult(alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText, style: .default, handler: alertModel.completion)

        alert.addAction(action)
        delegate?.didPresentAlert(alert: alert)
       
        
    }
    
    
}

