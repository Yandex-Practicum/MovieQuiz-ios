//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Nikolay Kozlov on 11.05.2023.
//

import UIKit

struct QuizStepViewModel {
    // картинка с афишей фильма с типом UIImage
    let image: UIImage
    // вопрос о рейтинге квиза
    let question: String
    // строка с порядковым номером этого вопроса (ex. "1/10")
    let questionNumber: String
}
