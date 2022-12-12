//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ruslan Batalov on 09.11.2022.
//


import UIKit

struct AlertPresenter: AlertPresenterProtocol {
   
    
    
    
    weak var viewController: UIViewController?
   
    
    mutating func show(results: AlertModel) {
        let alert = UIAlertController(title: results.title, message: results.message,                                preferredStyle: .alert)
        
    alert.view.accessibilityIdentifier! = "alert"
        
        let action = UIAlertAction(title: results.buttonText, style: .default, handler: results.completion)
            alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
     alert.view.accessibilityIdentifier = "alert"
        
    }
    
    
    
}












