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
    
    private var currentQuestionIndex : Int = 0 // индекс текущего вопроса
    private var correctAnswers: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    
    init(delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
    
    
    
    func makeAlertController(alertModel: AlertModel ) {
        let alert = UIAlertController (
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
           let completion = UIAlertAction(title : alertModel.buttonText, style: .default) { [weak self] _ in
            
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0 //Обнуляем счетчик правильных ответов
            
            self.questionFactory?.requestNextQuestion()
        }
        
        alert.addAction(completion)
        delegate?.didRecieveAlertModel(alertModel: alertModel)
        
    }
    
}
