//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Alexander Farizanov on 02.12.2022.
//

import Foundation
import UIKit
class QuestionFactory: QuestionFactoryProtocol {
    
    var delegate: QuestionFactoryDelegate? 
    
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
   // func requestNextQuestion() -> QuizQuestion? {
       // guard let index = (0..<questions.count).randomElement() else {
        //    return nil
    //    let index = 1  //  для проверки, ошибка такая же.... не понятно. Рендом тут не причем, получается
        //}
     //   return questions[safe: index]
  //  }
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {  // 2
             delegate?.didReceiveNextQuestion(question: nil)
             return
        }
        
        let question = questions[safe: index]
        delegate?.didRecieveNextQuestion(question: question)
    }
    
    
}
