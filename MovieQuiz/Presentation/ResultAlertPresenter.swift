//
//  ResultAlertPresenter.swift
//  MovieQuiz
//
//  Created by Mikhail Frantsuzov on 14.11.2023.
//

import Foundation
import UIKit

protocol ResultAlertPresenter {
    
    func show(alertModel: AlertModel)
}

final class ResultAlertPresenterImplementation {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
}

extension ResultAlertPresenterImplementation: ResultAlertPresenter {
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.tittle,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            
            alertModel.buttonAction()
        }
        
        alert.addAction(action)
        
        viewController?.present(alert, animated: true)
    }
}
