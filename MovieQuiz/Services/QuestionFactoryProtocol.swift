//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Даниил Романов on 04.03.2024.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
}
