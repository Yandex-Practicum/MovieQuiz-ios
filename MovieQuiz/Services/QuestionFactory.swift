//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Андрей Парамонов on 10.01.2023.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?
    private var current = -1

    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }

    func requestNextQuestion() {
        let index = generateNext()
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }

    private func generateNext() -> Int {
        var index: Int?
        repeat {
            index = (0..<questions.count).randomElement()
        } while (index == nil || index == current)
        current = index!
        return current
    }

    private let questions: [QuizQuestion] = [
        QuizQuestion(
                image: "The Godfather",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
        QuizQuestion(
                image: "The Dark Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
        QuizQuestion(
                image: "Kill Bill",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
        QuizQuestion(
                image: "The Avengers",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
        QuizQuestion(
                image: "Deadpool",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
        QuizQuestion(
                image: "The Green Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
        QuizQuestion(
                image: "Old",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
        QuizQuestion(
                image: "The Ice Age Adventures of Buck Wild",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
        QuizQuestion(
                image: "Tesla",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
        QuizQuestion(
                image: "Vivarium",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false)
    ]
}
