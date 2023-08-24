//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 03.08.2023.
//
import UIKit

// MARK: - AlertPresenterProtocol
protocol AlertPresenterProtocol {
    var delegate: MovieQuizViewController? { get }
    func alert(with model: AlertModel)
}

// MARK: - AlertPresenter Class
/// Presents Alert View
final class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: MovieQuizViewController?
    
    init(delegate: MovieQuizViewController) {
        self.delegate = delegate
    }
    
    /// Отображение уведомления о результатах игры
    ///     - model: AlertModel-структура
    func alert(with model: AlertModel) {
        
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default, handler: model.completion)
        
        alert.addAction(action)
        alert.view.accessibilityIdentifier = "Game results"
        
        delegate?.present(alert, animated: true)
    }
}

