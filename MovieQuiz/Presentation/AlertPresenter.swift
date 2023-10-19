//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Паша Шатовкин on 19.10.2023.
//

import Foundation
import UIKit

class AlertPresenter {
    
    weak var view: UIViewController?
    init(view: UIViewController?) {
        self.view = view
    }
    
    func show(result: AlertModel){
        let alert = UIAlertController(title: result.title, 
                                      message: result.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.buttonAction()
        }
        alert.addAction(action)
        view?.present(alert, animated: true, completion: nil)
    }
    
    
}
