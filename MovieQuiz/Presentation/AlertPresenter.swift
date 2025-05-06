//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Alexey Ponomarev on 19.04.2023.
//

import UIKit

class AlertPresenter {
    
    weak var view: UIViewController?
    
    init(view: UIViewController? = nil) {
        self.view = view
    }

    func show(data: AlertModel) {
        let alert = UIAlertController(
            title: data.title,
            message: data.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: data.buttonText, style: .default) { _ in
            data.completion()
        }
    
        alert.addAction(action)

        view?.present(alert, animated: true, completion: nil)
    }
}
