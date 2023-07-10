//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 09.07.2023.
//

import Foundation


/// Фабрика вопросов
///
class QuestionFactory: QuestionFactoryProtocol {
    
    /// Массив вопросов
    private var questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]
    
    /// Метод возвращающий опциональную модель вопроса - QuizQuestion
    func requestNextQuestion() -> QuizQuestion? {
        
        // Проверяем возможность выбора произвольного элемента из массива вопросов
        guard let index = (0..<questions.count).randomElement() else {
            return nil
        }
        
        // Возвращаем произвольный вопрос из массива
        return questions[safe: index]
    }
}
