//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by kamila on 28.01.2024.
//

import Foundation

protocol QuestionFactoryProtocol{
    var delegate: QuestionFactoryDelegate? { get set}
    func requestNextQuestion()
}
