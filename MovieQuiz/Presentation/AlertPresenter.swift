//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Artem Adiev on 07.12.2022.
//
import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    private weak var controller: UIViewController?
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    
    func showAlert(model: AlertModel) {
        
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Game results"
        
        let action = UIAlertAction(
            title: "Сыграть еще раз",
            style: .default,
            handler: { _ in model.completion() }
        )
        
        alert.addAction(action)
        controller?.present(alert, animated: true, completion: nil)
        
    }
    
}
