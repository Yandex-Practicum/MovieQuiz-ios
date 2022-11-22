//
//  Models.swift
//  MovieQuiz
//
//  Created by Viktoria Lobanova on 22.11.2022.
//

import Foundation
import UIKit

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

// для состояния "Вопрос задан"
struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
    
}

// для состояния "Результат квиза"
struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}
