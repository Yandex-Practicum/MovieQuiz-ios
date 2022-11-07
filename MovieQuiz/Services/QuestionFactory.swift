//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Konstantin Zuykov on 07.11.2022.
//

import Foundation

fileprivate let questionString: String = "Рейтинг этого фильма больше чем 6?"

class QuestionFactory {

    func requestNextQuestion() -> QuizQuestion? {
        guard let index = (0..<questions.count).randomElement() else {
            return nil
        }
        return questions[safe: index]
    }

    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: questionString, correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: questionString, correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: questionString, correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: questionString, correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: questionString, correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: questionString, correctAnswer: true),
        QuizQuestion(image: "Old", text: questionString, correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: questionString, correctAnswer: false),
        QuizQuestion(image: "Tesla", text: questionString, correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: questionString, correctAnswer: false)
    ]
}
