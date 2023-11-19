//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Федор Завьялов on 19.11.2023.
//

import UIKit

class AlertPresenter {
    
    var alert: AlertModel?
    
    func showAlert(quiz result: AlertModel?){
        guard let result else { return }
        //Создаем Alert
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            
            guard let selfAction = self else { return }
            // обнуляем счетчик вопросов
            selfAction.correctAnswers = 0
            
            // обнуляем счетчик правильных вопросов
            selfAction.currentQuestionIndex = 0
            
            //Загружаем на экран первый вопрос
            selfAction.questionFactory.requestNextQuestion()
        }
        
        //Создаем действие Alert и выводим его на экран
        alert.addAction(result.completion)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
