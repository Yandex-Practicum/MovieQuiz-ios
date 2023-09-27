//
//  File.swift
//  MovieQuiz
//
//  Created by Артем Чалков on 12.10.2023.
//

import Foundation

class QuestionFactory {
    var questions = [
        QuizQuestion.init(id: 1, image: "The Godfather", rating: 9.2, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        QuizQuestion.init(id: 1, image: "The Dark Knight", rating: 9, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        QuizQuestion.init(id: 1, image: "Kill Bill", rating: 8.1, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        QuizQuestion.init(id: 1, image: "The Avengers", rating: 8, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        QuizQuestion.init(id: 1, image: "Deadpool", rating: 8, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        QuizQuestion.init(id: 1, image: "The Green Knight", rating: 6.6, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        QuizQuestion.init(id: 1, image: "Old", rating: 5.8, question: "Рейтинг этого фильма больше чем 6?", answer: "Нет"),
        QuizQuestion.init(id: 1, image: "The Ice Age Adventures of Buck Wild", rating: 4.3, question: "Рейтинг этого фильма больше чем 6?", answer: "Нет"),
        QuizQuestion.init(id: 1, image: "Tesla", rating: 5.1, question: "Рейтинг этого фильма больше чем 6?", answer: "Нет"),
        QuizQuestion.init(id: 1, image: "Vivarium", rating: 5.8, question: "Рейтинг этого фильма больше чем 6?", answer: "Нет")
        
    ]
//    func requestNextQuestion() -> QuizQuestion? { // 1
//        // 2
//        guard let index = (0..<questions.count).randomElement() else {
//            return nil
//        }
//
//        return questions[safe: index] // 3
//    }
//    
//    subscript(index: Int) -> Int {
//        get {
//            // Возвращаем соответствующее значение
//        }
//        set(newValue) {
//            // Устанавливаем подходящее значение
//        }
//    }
}


