//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by LERÄ on 11.09.23.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
