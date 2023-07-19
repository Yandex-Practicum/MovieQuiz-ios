//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 09.07.2023.
//

import Foundation

// MARK: - Фабрика вопросов
final class QuestionFactory: QuestionFactoryProtocol {
    
    /// Делегат - получатель Квиз-вопросов
    weak var delegate: QuestionFactoryDelegate?
    
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
    
    /// Инициализация фабрики вопросов с иньекцией делегата
    init(delegate: QuestionFactoryDelegate){
        self.delegate = delegate
    }
    
    /// Метод возвращающий опциональную модель вопроса - QuizQuestion
    func requestNextQuestion(){
        
        // Проверяем возможность выбора произвольного элемента из массива вопросов
        guard let index = (0..<questions.count).randomElement() else {
            return
        }
        
        // Возвращаем произвольный вопрос из массива
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
}

// MARK: - QuestionFactoryProtocol
//
protocol QuestionFactoryProtocol {
    func requestNextQuestion()
}

// MARK: - QuestionFactoryDelegate
//
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
