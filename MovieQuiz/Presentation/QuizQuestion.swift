//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Murad Azimov on 30.10.2023.
//

import Foundation

struct QuizQuestion {
  let image: String
  let text: String
let correctAnswer: Bool
}

private let question = "Рейтинг этого фильма больше чем 6?"

let questionsMock: [QuizQuestion] = [
    QuizQuestion(image: "The Godfather", text: question, correctAnswer: true),
    QuizQuestion(image: "The Dark Knight", text: question, correctAnswer: true),
    QuizQuestion(image: "Kill Bill", text: question, correctAnswer: true),
    QuizQuestion(image: "The Avengers", text: question, correctAnswer: true),
    QuizQuestion(image: "Deadpool", text: question, correctAnswer: true),
    QuizQuestion(image: "The Green Knight", text: question, correctAnswer: true),
    QuizQuestion(image: "Old", text: question, correctAnswer: false),
    QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: question, correctAnswer: false),
    QuizQuestion(image: "Tesla", text: question, correctAnswer: false),
    QuizQuestion(image: "Vivarium", text: question, correctAnswer: false)
]
