//
//  QuizResultsViewModel.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 10.07.2023.
//

import Foundation

/// Структура модели отображаемого уведомления с результатами
/// - Parameters:
///     - title: Заголовок уведомления
///     - text: Строка с текстом о количестве набранных очков
///     - buttonText: Текст кнопки уведомления
struct QuizResultsViewModel {
    
    let title: String
    let text: String
    let buttonText: String
}
