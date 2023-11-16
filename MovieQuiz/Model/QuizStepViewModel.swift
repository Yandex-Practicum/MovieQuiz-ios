//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Муртазали Магомедов on 08.11.2023.
//

import Foundation
import UIKit

// для состояния "Вопрос показан"
struct QuizStepViewModel {
    // навзание фотографии
  let image: UIImage
    // строка с вопросом
  let question: String
    // строка с номером вопроса
  let questionNumber: String
}

// для состояния "Результат квиза"
struct QuizResultsViewModel {
  // строка с заголовком алерта
  let title: String
  // строка с текстом о количестве набранных очков
  let text: String
  // текст для кнопки алерта
  let buttonText: String
}
