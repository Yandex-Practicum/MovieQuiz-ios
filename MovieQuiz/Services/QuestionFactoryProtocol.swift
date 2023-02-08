//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Баир Шаралдаев on 04.02.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
}
extension QuestionFactory: QuestionFactoryProtocol {
}
