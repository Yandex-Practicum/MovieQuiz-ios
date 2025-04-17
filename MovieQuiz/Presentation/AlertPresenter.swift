//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Денис Петров on 17.12.2023.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol  {
    func showResults(alertModel : AlertModel) -> Void
}

class AlertPresenter : AlertPresenterProtocol{
    weak var uiViewController: UIViewController?
    
    func showResults(alertModel: AlertModel) {
        guard let uiViewController = uiViewController else {return}
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) {_ in
            alertModel.completion()
        }
        
        alert.addAction(action)
        
        uiViewController.present(alert, animated: true, completion: alertModel.completion)
    }
}
