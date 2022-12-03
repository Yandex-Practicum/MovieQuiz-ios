//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
