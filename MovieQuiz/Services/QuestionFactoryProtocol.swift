//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Mir on 19.03.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
