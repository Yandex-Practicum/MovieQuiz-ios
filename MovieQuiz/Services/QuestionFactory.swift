//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Respect on 09.11.2022.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
                    image: "The Godfather",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true
        ),
        QuizQuestion(
                    image: "The Dark Knight",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true
        ),
        QuizQuestion(
                    image: "Kill Bill",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true
        ),
        QuizQuestion(
                    image: "The Avengers",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true
        ),
        QuizQuestion(
                    image: "Deadpool",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true
        ),
        QuizQuestion(
                    image: "The Green Knight",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true
        ),
        QuizQuestion(
                    image: "Old",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: false
        ),
        QuizQuestion(
                    image: "The Ice Age Adventures of Buck Wild",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: false
        ),
        QuizQuestion(
                    image: "Tesla",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: false
        ),
        QuizQuestion(
                    image: "Vivarium",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: false
        )
    ]
    
    //MARK: - init
    
    init(delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
    }
    
    // MARK: - Func
    
    func requestNextQuestion(){
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didRecieveNextQuestion(question: nil)
            return
        }
        let question = questions[safe: index]
        delegate?.didRecieveNextQuestion(question: question)
    }
    
}

