//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Илья Дышлюк on 09.12.2023.
//


import UIKit

class AlertPresenter {
    
     var view: UIViewController
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func show(data: AlertModel) {
        let alert = UIAlertController(
            title: data.title,
            message: data.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: data.buttontext, style: .default) { _ in
            data.buttonAction()
        }
        
        alert.addAction(action)
        
        view.present(alert, animated: true, completion: nil)
    }
}
