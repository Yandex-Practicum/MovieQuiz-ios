//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Александра Коснырева on 07.09.2023.
//

import Foundation



final class QuestionFactory: QuestionFactoryProtocol {
    
    private let questions: [QuizQuestion] = [
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
    
    func requestNextQuestion() {                       // request - запрос
        guard let index = (0..<questions.count).randomElement() else {
            delelgate?.didReceiveNextQuestion(question: nil)
            return
        }
        let question = questions[safe: index]
        delelgate?.didReceiveNextQuestion(question: question)
    }
    
    weak var delelgate: QuestionFactoryDelegate? //такая связь между классами называется агрегацией
    init(delegate: QuestionFactoryDelegate) {
        self.delelgate = delegate
    }
}


