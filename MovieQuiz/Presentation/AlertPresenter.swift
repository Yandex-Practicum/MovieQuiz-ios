//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by tommy tm on 08.12.2022.
//

import Foundation
import UIKit

struct AlertPresenter: AlertProtocol {
    
    weak var viewController: UIViewController?
    
    func show(result: AlertModel) {
        let alert = UIAlertController(
                                    title: result.title,
                                    message: result.message,
                                    preferredStyle: .alert)
            
        let action = UIAlertAction(title: result.buttonText, style: .default)
        
        
        alert.addAction(action)
            
        viewController?.present(alert, animated: true, completion: nil)
}
}
