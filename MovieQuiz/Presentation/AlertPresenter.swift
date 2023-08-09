//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 03.08.2023.
//

import UIKit

// MARK: - AlertPresenter Class

final class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func alert(with model: AlertModel) {
        
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default, handler: model.completion)
        
        alert.addAction(action)
        
        delegate?.present(alert, animated: true)
    }
}


// MARK: - AlertPresenterProtocol
///
protocol AlertPresenterProtocol {
    var delegate: AlertPresenterDelegate? { get }
    func alert(with model: AlertModel)
}

// MARK: - AlertPresenterDelegate

protocol AlertPresenterDelegate: UIViewController {
    func startNewQuiz(_: UIAlertAction)
}

