//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Ислам Нурмухаметов on 07.09.2022.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    private let questions = [
        QuizQuestion(
                image: "Deadpool",
                text: "Рейтинг этого фильма меньше, чем 6?",
                correctAnswer: true),
        QuizQuestion(
                image: "The Green Knight",
                text: "Рейтинг этого фильма меньше, чем 6?",
                correctAnswer: true),
        QuizQuestion(
                image: "Old",
                text: "Рейтинг этого фильма меньше, чем 6?",
                correctAnswer: false),
        QuizQuestion(
                image: "The Ice Age Adventures of Buck Wild",
                text: "Рейтинг этого фильма меньше, чем 6?",
                correctAnswer: false),
        QuizQuestion(
                image: "Tesla",
                text: "Рейтинг этого фильма меньше, чем 6?",
                correctAnswer: false),
        QuizQuestion(
                image: "Vivarium",
                text: "Рейтинг этого фильма меньше, чем 6?",
                correctAnswer: false),
        QuizQuestion(
                image: "The Avengers",
                text: "Рейтинг этого фильма меньше, чем 6?",
                correctAnswer: true),
        QuizQuestion(
                image: "Kill Bill",
                text: "Рейтинг этого фильма меньше, чем 6?",
                correctAnswer: true),
        QuizQuestion(
                image: "The Dark Knight",
                text: "Рейтинг этого фильма меньше, чем 6?",
                correctAnswer: true),
        QuizQuestion(
                image: "The Godfather",
                text: "Рейтинг этого фильма меньше, чем 6?",
                correctAnswer: true)
    ]

    func requestNextQuestion(completion: (QuizQuestion?) -> Void) {
        let index = (0..<questions.count).randomElement() ?? 0
        let question = questions[safe: index]

        completion(question)
    }
}
