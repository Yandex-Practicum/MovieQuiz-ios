//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 11.07.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
