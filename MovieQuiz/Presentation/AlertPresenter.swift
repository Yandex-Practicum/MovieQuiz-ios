//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Александр Ершов on 03.12.2022.
//


import UIKit

struct AlertPresenter: AlertPresenterProtocol{
    
    weak var viewController: UIViewController?
    
    func show(results: AlertModel) {
        
        let alert = UIAlertController(title: results.title,
                                      message: results.message,
                                      preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "AlertResult"
        let action = UIAlertAction(title: results.buttonText,
                                   style: .default)
        
        
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
        
    }
}

