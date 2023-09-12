//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Глеб Хамин on 25.09.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    var delegate: QuestionFactoryDelegate? { get set }
}
