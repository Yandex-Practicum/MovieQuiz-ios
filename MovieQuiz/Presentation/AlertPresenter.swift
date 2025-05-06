//
//  AlertPresentor.swift
//  MovieQuiz
//
//  Created by Bakhadir on 28.09.2023.
//

import Foundation
import UIKit

protocol AlertPresenter: AnyObject {
    
    func show(with alertModel: AlertModel)
}

final class AlertPresenterImpl {
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

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
