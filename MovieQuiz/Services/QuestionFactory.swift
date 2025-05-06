//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by admin on 04.06.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveQuestion(_ question: QuizQuestion)
}

protocol QuestionFactory {
    func requestNextQuestion()
}

final class QuestionFactoryImpl {
    
    // MARK: - Properies
    
    private  weak  var delegate: QuestionFactoryDelegate?
    
    // MARK: - Init
    
    init(delegate: QuestionFactoryDelegate? = nil) {
        self.delegate = delegate
    }
}

extension QuestionFactoryImpl: QuestionFactory {
    func requestNextQuestion() {
        
        let questions: [QuizQuestion] = [
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
        
        guard let question = questions.randomElement() else {
            assertionFailure(" question is empty")
            return
        }
        
        delegate?.didRecieveQuestion(question)
    }
}

