//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Mikhail Vostrikov on 19.04.2023.
//

import UIKit


protocol AlertPresenter {
    
    func show(alertModel: AlertModel)
}

final class AlertPresenterImpl {
    private weak var viewContoller: UIViewController?
    
    init(viewContoller: UIViewController? = nil) {
        self.viewContoller = viewContoller
    }
}

extension AlertPresenterImpl: AlertPresenter {
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.buttonAction()
        }
        
        alert.addAction(action)
        
        viewContoller?.present(alert, animated: true)
    }
}
