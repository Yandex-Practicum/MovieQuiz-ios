//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Александр Сироткин on 25.11.2022.
//

import Foundation

class QuestionFactory : QuestionFactoryProtocol {

    private var previousIndex: Int? = nil
    weak var delegate: QuestionFactoryDelegate?

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

    func requestNextQuestion() {
        guard let index = getIndex() else {
            delegate?.didRecieveNextQuestion(question: nil)
            return
        }
        delegate?.didRecieveNextQuestion(question: questions[safe: index])
    }

    func setDelegate(delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
    }

    private func getIndex() -> Int? {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didRecieveNextQuestion(question: nil)
            return nil
        }
        if index == previousIndex {
            return getIndex()
        }
        previousIndex = index
        return index
    }

}
