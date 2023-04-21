//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Kuimova Olga on 19.04.2023.
//

import Foundation
import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController?) {
        self.delegate = delegate
    }
    
    func showAlert(alertFinish: AlertModel) {
        let alert = UIAlertController(title: alertFinish.title,
                                      message: alertFinish.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertFinish.buttonText, style: .default, handler: { _ in
            alertFinish.completion?()
        })
        alert.addAction(action)
        delegate?.present(alert, animated: true)
    }
    
}
