//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Yuriy Varvenskiy on 17.08.2023.
//

import Foundation
import UIKit

final class AlertPresenter {
    private let controller: AnyObject
    private let model: AlertModel
    private let alert: UIAlertController
    
    init(controller: AnyObject, model: AlertModel) {
        self.controller = controller
        self.model = model
        
        self.alert = UIAlertController(title: self.model.title, message: self.model.message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: self.model.buttonText, style: .default) { _ in
            self.model.completion()
        }
        
        self.alert.addAction(action)
    }
    
    func run() -> Void {
        controller.present(self.alert, animated: true, completion: nil)
    }
}
