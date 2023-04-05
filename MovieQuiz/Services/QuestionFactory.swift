//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Ina on 16/03/2023.
//
import Foundation
private let description = "Рейтинг этого фильма больше чем 6?"

final class QuestionFactory: QuestionFactoryProtocol {
  
    weak var delegate: QuestionFactoryDelegate?
    
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: description,
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: description,
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: description,
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: description,
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: description,
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: description,
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: description,
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: description,
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: description,
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: description,
            correctAnswer: false)
    ]
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
}
