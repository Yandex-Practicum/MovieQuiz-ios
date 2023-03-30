//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Mir on 18.03.2023.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather",
                     correctAnswer: true),
        QuizQuestion(image: "The Dark Knight",
                     correctAnswer: true),
        QuizQuestion(image: "Kill Bill",
                     correctAnswer: true),
        QuizQuestion(image: "The Avengers",
                     correctAnswer: true),
        QuizQuestion(image: "Deadpool",
                     correctAnswer: true),
        QuizQuestion(image: "The Green Knight",
                     correctAnswer: true),
        QuizQuestion(image: "Old",
                     correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                     correctAnswer: false),
        QuizQuestion(image: "Tesla",
                     correctAnswer: false),
        QuizQuestion(image: "Vivarium",
                     correctAnswer: false)
    ]
    
    private var usedIndexes: Set<Int> = []
       
       func requestNextQuestion() {
           var index = Int.random(in: 0..<questions.count)
           
           // Если индекс использовали - выбираем другой
           while usedIndexes.contains(index) {
               index = Int.random(in: 0..<questions.count)
           }
           
           usedIndexes.insert(index)
           
           let question = questions[safe: index]
           delegate?.didRecieveNextQuestion(question: question)
       }
       
       init(delegate: QuestionFactoryDelegate) {
           self.delegate = delegate
       }
   }

