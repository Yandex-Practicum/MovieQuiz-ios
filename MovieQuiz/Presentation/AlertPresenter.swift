//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 08.02.2023.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterprotocol {
    
    private weak var delegate: AlertPresenterDelegate?
    

    
    init(delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
    
    
    
    func makeAlertController(alertModel: AlertModel ) {
        let alert = UIAlertController (
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
           let completion = UIAlertAction(title : alertModel.buttonText, style: .default) {  _ in
               alertModel.completion()
            
            
//            self.currentQuestionIndex = 0
//            self.correctAnswers = 0 //Обнуляем счетчик правильных ответов
//            
//            self.questionFactory?.requestNextQuestion()
        }
        
        alert.addAction(completion)
        delegate?.present(alert)
        
    }
    
}
