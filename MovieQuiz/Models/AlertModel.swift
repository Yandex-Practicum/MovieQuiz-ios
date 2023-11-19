//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Федор Завьялов on 19.11.2023.
//

import UIKit

//Структруа вызова уведомления
struct AlertModel {
    
    var title: String
    
    var message: String
    
    var buttonText: String
    
    var completion: () -> Void {
        let action = UIAlertAction(title: self.buttonText, style: .default) { [weak MovieQuizViewController] _ in
            
            guard let selfAction = MovieQuizViewController else { return }
            // обнуляем счетчик вопросов
            selfAction.correctAnswers = 0
            
            // обнуляем счетчик правильных вопросов
            selfAction.currentQuestionIndex = 0
            
            //Загружаем на экран первый вопрос
            selfAction.questionFactory.requestNextQuestion()
        }
    }
    
}
