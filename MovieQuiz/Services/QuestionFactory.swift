//
//  File.swift
//  MovieQuiz
//
//  Created by Артем Чалков on 12.10.2023.
//

import Foundation

class QuestionFactory {
    
    var questionsAmount: Int = 10
    
    lazy var copyMovies = questions
    
    var questions = [
        QuizQuestion.init(id: 1, image: "The Godfather", rating: 9.2, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        QuizQuestion.init(id: 2, image: "The Dark Knight", rating: 9, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        QuizQuestion.init(id: 3, image: "Kill Bill", rating: 8.1, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        QuizQuestion.init(id: 4, image: "The Avengers", rating: 8, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        QuizQuestion.init(id: 5, image: "Deadpool", rating: 8, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        QuizQuestion.init(id: 6, image: "The Green Knight", rating: 6.6, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        QuizQuestion.init(id: 7, image: "Old", rating: 5.8, question: "Рейтинг этого фильма больше чем 6?", answer: "Нет"),
        QuizQuestion.init(id: 8, image: "The Ice Age Adventures of Buck Wild", rating: 4.3, question: "Рейтинг этого фильма больше чем 6?", answer: "Нет"),
        QuizQuestion.init(id: 9, image: "Tesla", rating: 5.1, question: "Рейтинг этого фильма больше чем 6?", answer: "Нет"),
        QuizQuestion.init(id: 10, image: "Vivarium", rating: 5.8, question: "Рейтинг этого фильма больше чем 6?", answer: "Нет")
        
    ]
    
    func requestNextQuestion() -> QuizQuestion? {
        
        guard let question = copyMovies.randomElement() else { return nil }
        
        copyMovies.removeAll(where: { $0.id == question.id } )
        
        return question
    }
}


