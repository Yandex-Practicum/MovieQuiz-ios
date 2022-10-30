//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Alexey Tsidilin on 26.10.2022.
//

import Foundation
import UIKit

/*
 
 class AlertPresenter {
    
    private func show(quiz result: QuizResultsViewModel) {
        // здесь мы показываем результат прохождения квиза
        // создаём объекты всплывающего окна
        let alert = UIAlertController(
            title: result.title, // заголовок всплывающего окна
            message: result.text, // текст во всплывающем окне
            preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet
        
        // создаём для него кнопки с действиями
        let action = UIAlertAction(
            title: result.buttonText,
            style: .default,
            handler: { [weak self] _ in
            guard let self = self else { return }
            print("Repeat button is clicked!")
            
            // скидываем счётчик правильных ответов
            self.numberOfCorrectAnswers = 0
            self.currentQuestionIndex = 0
            
            // заново показываем первый вопрос
            self.questionFactory?.requestNextQuestion()
        })
        
        // добавляем в алерт кнопки
        alert.addAction(action)
        
        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }

}
 
 */
