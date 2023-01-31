//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ruslan Batalov on 09.11.2022.
//

import Foundation
import UIKit


struct AlertPresenter: AlertPresenterProtocol {
    
    weak var viewController: UIViewController?
    
    func show(results: AlertModel) {
        
        let alert = UIAlertController(title: results.title, message: results.message,                                preferredStyle: .alert)
        
        let action = UIAlertAction(title: results.buttonText, style: .default, handler: results.completion)
        
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
        
    }
    
    
}











