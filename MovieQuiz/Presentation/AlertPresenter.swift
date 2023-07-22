//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ivan on 12.07.2023.
//
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func showQuizResult(for model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default) { _ in
                model.completition()
            }
        
        alert.addAction(action)
        
        delegate?.present(alert, animated: true, completion: nil)
        
    }
}

