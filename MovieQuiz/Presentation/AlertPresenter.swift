//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Федор Завьялов on 19.11.2023.
//

import Foundation

class AlertPresenter {
    
    var alert: AlertModel?
    
    private func showAlert(quiz result: QuizResultViewModel){
        //Создаем Alert
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
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
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
