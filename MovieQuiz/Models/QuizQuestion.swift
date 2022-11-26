//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Veniamin on 11.11.2022.
//

import Foundation

//MARK: модель информация про вопрос на экране только на уровне данных
//struct QuizQuestion {
//  let image: String
//  let text: String
//  let correctAnswer: Bool
//}

struct QuizQuestion{
    let image: Data
    let text: String
    let correctAnswer: Bool
}
