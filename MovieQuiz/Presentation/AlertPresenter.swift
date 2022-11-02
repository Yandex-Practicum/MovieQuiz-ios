//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Слава Шестаков on 02.11.2022.
//

import UIKit

struct AlertPresenter {
    
    weak var delegate: UIViewController?
    
    func showAlert(alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: .alert)

        let action = UIAlertAction(title: alertModel.buttonText, style: .default, handler: alertModel.completion)
        
        alert.addAction(action)

        delegate?.present(alert, animated: true, completion: nil)
    }
    
}
