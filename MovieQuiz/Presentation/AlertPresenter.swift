//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by kamila on 05.02.2024.
//

import UIKit

protocol AlertPresenterProtocol {
    var delegate: UIViewController? {get set}
    func show(alertModel: AlertModel)
}

final class AlertPresenter {
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController? = nil) {
        self.delegate = delegate
    }
    
    func show(alertModel: AlertModel){
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.buttonAction()
        }
        alert.addAction(action)
        delegate?.present(alert, animated: true)
    }
}
