//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by   apollo on 02.12.2022.
//


import UIKit
    
struct ResultAlertPresenter {

    var delegate: AlertPresenterDelegate?
    
    func present(alert: AlertModel){
   let alertController = UIAlertController(title: alert.title,
                                  message: alert.message,
                                  preferredStyle: .alert)
    
    let action = UIAlertAction(title: alert.buttonText,
                               style: .default, handler: alert.completion)
    
    
   alertController.addAction(action)
    
        delegate?.didPresentAlert(alert: alertController)
    }
}
    
