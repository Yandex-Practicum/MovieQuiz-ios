//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Иван Корнев on 25.11.2023.
//

import Foundation
import UIKit

final class ResultAlertPresenter {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func show(alertModel: alertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            
            alertModel.completion()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}
