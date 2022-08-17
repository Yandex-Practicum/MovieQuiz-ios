//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by  admin on 12.08.2022.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    private let delegate: QuestionFactoryDelegate
    private var questions: [QuizeQuestion] = [
        QuizeQuestion(image: "The Godfather",text: "Рейтинг этого замечательного фильма \"Крестный отец\" больше, чем 6?" ,correctAnswer: true),
        QuizeQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true),
        QuizeQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true),
        QuizeQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true),
        QuizeQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true),
        QuizeQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true),
        QuizeQuestion(image: "Old", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: false),
        QuizeQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: false),
        QuizeQuestion(image: "Tesla", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: false),
        QuizeQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: false)
    ]

    func requestNextQuestion() {
        let index = (0..<questions.count).randomElement() ?? 0
        let question = questions[safe: index]
        delegate.didReceiveNextQuestion(question: question)
    }
    
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
}


