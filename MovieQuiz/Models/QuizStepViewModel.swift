//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by DANCECOMMANDER on 17.04.2023.
//

import UIKit

// Для состояния "Вопрос показан"
struct QuizStepViewModel {
    // Картинка с афишей фильма
    let image: UIImage
    // Вопрос о рейтинге фильма
    let question: String
    // Строка в порядковым номером вопроса 1/10
    let questionNumber: String
}

