//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Александр Сироткин on 25.11.2022.
//

import Foundation

class QuestionFactory : QuestionFactoryProtocol {

    private weak var delegate: QuestionFactoryDelegate?

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
            text: "Она убила Балла к конце?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Avengers",
            text: "Это фильм для взрослых?",
            correctAnswer: false),
        QuizQuestion(
            image: "Deadpool",
            text: "Макконахи сыграл главную роль?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 5?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 4?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Это фильм для детей?",
            correctAnswer: true),
        QuizQuestion(
            image: "Tesla",
            text: "Этот фильм про автомобили?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Этот фильм популярный?",
            correctAnswer: false)
    ]

    private var index = 0
    private var indexes: [Int] = []

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
        if questions.isEmpty {
            return nil
        }
        if questions.count == 1 {
            return 0
        }
        return getIndexImpl()
    }

    private func getIndexImpl() -> Int {
        if index == questions.count {
            let currentIndex = indexes.last
            index = 0
            while true {
                indexes.shuffle()
                if indexes.first != currentIndex {
                    break
                }
            }
        }
        if indexes.isEmpty {
            for i in 0..<questions.count {
                indexes.append(i)
            }
            indexes.shuffle()
        }
        let currentIndex = indexes[index]
        index += 1
        return currentIndex
    }

}
