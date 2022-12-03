//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Viktoria Lobanova on 30.11.2022.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
}
