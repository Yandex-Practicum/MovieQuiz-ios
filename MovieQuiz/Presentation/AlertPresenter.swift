//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Артур Коробейников on 31.01.2023.
//

import Foundation
import UIKit

class AlertPresenter {
    
    func present(view controller: UIViewController, alert model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default, handler: model.completion)
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
    
    /*weak var delegate: MovieQuizViewController?
    
    init(delegate: MovieQuizViewController?) {
        self.delegate = delegate
    }
     */
}
