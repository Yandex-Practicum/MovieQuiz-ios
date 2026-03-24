//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Flymetric on 19.02.2026.
//

import UIKit

    // вью модель для состояния "Вопрос показан"
struct QuizStepViewModel {
    // картинка с афишей фильма с типом UIImage
    var image: UIImage
    // вопрос о рейтинге квиза
    let question: String
    // строка с порядковым номером этого вопроса (ex. "1/10")
    let questionNumber: String
}
