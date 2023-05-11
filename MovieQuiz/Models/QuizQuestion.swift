//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by DANCECOMMANDER on 17.04.2023.
//

import Foundation

struct QuizQuestion {
    
    let image: Data
    // Строка с вопросом о рейтинге фильма
    let text: String
    // Булево значение true, false, правильный ответ на вопрос
    let correctAnswer: Bool
}
