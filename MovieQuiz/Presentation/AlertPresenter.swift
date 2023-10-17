//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Глеб Хамин on 09.10.2023.
//

import Foundation
import UIKit

protocol AlertPresenter: AnyObject {
    
    func show(with alertModel: AlertModel)
}

final class AlertPresenterImpl {
    
    // MARK: - Private Properties
    
    private let viewController: UIViewController
    
    // MARK: - Initializers
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

//MARK: - Alert Presenter

extension AlertPresenterImpl: AlertPresenter {
    
    func show(with alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.buttonAction()
        }
            
        alert.addAction(action)
        
        viewController.present(alert, animated: true)
    }
}

