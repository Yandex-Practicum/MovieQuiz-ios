//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Mir on 18.03.2023.
//

import UIKit

final class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
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
    
    // никак не получается реализовать функцию случайного выбора из оставшихся вопросов - кнопка сыграть еще раз на алерте ломается, приложение не перезапускается - никак не могу понять в чем дело
    /* private var usedIndexes: [Int] = []
    
    func requestNextQuestion() {
        
        var index = Int.random(in: 0..<questions.count)
        
        while usedIndexes.contains(index) {
            index = Int.random(in: 0..<questions.count)
        }
        
        usedIndexes.append(index)
        
        let question = questions[index]
        delegate?.didRecieveNextQuestion(question: question)
    } */
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            return
        }
        let question = questions[safe: index]
        delegate?.didRecieveNextQuestion(question: question)
    }
}
