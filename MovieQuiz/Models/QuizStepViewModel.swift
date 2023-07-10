//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 10.07.2023.
//
import UIKit

/// Структура модели вопроса
/// - Parameters:
///     - image: Изображение вопроса
///     - question: Текст вопроса
///     - questionNumber: Номер вопроса в квизе
struct QuizStepViewModel {
    
    let image: UIImage
    let question: String
    let questionNumber: String
}
