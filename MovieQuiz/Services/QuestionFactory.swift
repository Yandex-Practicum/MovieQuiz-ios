//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Sergey Telnov on 20/10/2023.
//

import Foundation
import UIKit

class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(filmName: "The Godfather", rating: 9.2, text: "Рейтинг этого фильма больше чем 6?", answer: true),
        QuizQuestion(filmName: "The Dark Knight", rating: 8.1, text: "Рейтинг этого фильма больше чем 6?", answer: true),
        QuizQuestion(filmName: "Kill Bill", rating: 8.1, text: "Рейтинг этого фильма больше чем 6?", answer: true),
        QuizQuestion(filmName: "The Avengers", rating: 8.0, text: "Рейтинг этого фильма больше чем 6?", answer: true),
        QuizQuestion(filmName: "Deadpool", rating: 8.0, text: "Рейтинг этого фильма больше чем 6?", answer: true),
        QuizQuestion(filmName: "The Green Knight", rating: 6.6, text: "Рейтинг этого фильма больше чем 6?", answer: true),
        QuizQuestion(filmName: "Old", rating: 5.8, text: "Рейтинг этого фильма больше чем 6?", answer: false),
        QuizQuestion(filmName: "The Ice Age Adventures of Buck Wild", rating: 4.3, text: "Рейтинг этого фильма больше чем 6?", answer: false),
        QuizQuestion(filmName: "Tesla", rating: 5.1, text: "Рейтинг этого фильма больше чем 6?", answer: false),
        QuizQuestion(filmName: "Vivarium", rating: 5.8, text: "Рейтинг этого фильма больше чем 6?", answer: false)
    ]
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else
        { delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        delegate?.didReceiveNextQuestion(question: questions[safe: index])
    }
    
}
