//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Мария Авдеева on 30.11.2022.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    var delegate: QuestionFactoryDelegate? { get set }
}
