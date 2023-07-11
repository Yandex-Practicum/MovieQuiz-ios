//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Андрей Чупрыненко on 10.07.2023.
//

import Foundation
import UIKit

class AlertPresenter {
    weak var viewController: UIViewController?
        
        init(viewController: UIViewController) {
            self.viewController = viewController
        }
        
    func showResultsAlert(_ alertModel: AlertModel) {
            let alert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
            let action = UIAlertAction(title: alertModel.buttonText, style: .default) {_ in
                alertModel.completion()
            }
            
            guard let viewController = viewController else { return }
            alert.addAction(action)
            viewController.present(alert, animated: true, completion: nil)
        }
}
