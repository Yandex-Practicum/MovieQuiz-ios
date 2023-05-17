//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Dmitrii on 17.05.2023.
//
import Foundation
import UIKit

class AlertPresenter {
    private let controller: AnyObject
    private let model: AlertModel
    private let alert: UIAlertController
    
    init(controller: AnyObject, model: AlertModel) {
        self.controller = controller
        self.model = model
        
        self.alert = UIAlertController(title: self.model.title, message: self.model.message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: self.model.buttonText, style: .default) { _ in
            self.model.completion?()
        }
        
        self.alert.addAction(action)
    }
    
    func run() -> Void {
        controller.present(self.alert, animated: true, completion: nil)
    }
}

/*
let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
    guard let self = self else { return }
    self.currentQuestionIndex = 0
    self.correctAnswers = 0
    questionFactory?.requestNextQuestion()
}

let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
alert.addAction(action)

self.present(alert, animated: true, completion: nil)
*/
