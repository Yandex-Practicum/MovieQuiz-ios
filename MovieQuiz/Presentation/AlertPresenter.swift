//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by macOS on 30.09.2022.
//

import Foundation
import UIKit

struct AlertPresenter {
    
    var viewController: UIViewController?
    
    func showAlert(alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default, handler: alertModel.buttonAction)
        alert.addAction(action)
        
        viewController?.present(alert, animated: true, completion: nil)
    }
    
}
