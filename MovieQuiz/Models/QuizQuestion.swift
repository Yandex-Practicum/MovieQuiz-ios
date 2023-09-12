//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Дмитрий Калько on 12.09.2023.
//

import Foundation

public struct QuizQuestion {
    // строка с названием фильма
    //совпадает с названием афиши фильма в assets
    let image: String
    // строка с вопросом о рейтинге фильма
    let text: String
    // буллево значение правильный ответ на вопрос
    let correctAnswer: Bool
}
