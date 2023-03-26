//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Mir on 26.03.2023.
//

import UIKit

final class AlertPresenter {
    private let alert: AlertModel
    
    init(title: String,
         message: String,
         buttonText: String,
         completion: @escaping (() -> ()))
    {
        self.alert = AlertModel(title: title,
                                message: message,
                                buttonText: buttonText,
                                completion: completion)
    }
    
    func show(viewController: UIViewController) {
        let alert = UIAlertController(title: self.alert.title,
                                      message: self.alert.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: self.alert.buttonText,
                                   style: .default) { _ in
            self.alert.completion()
        }
        
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}
