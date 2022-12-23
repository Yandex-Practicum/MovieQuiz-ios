//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Gennadii Kulikov on 03.12.2022.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
    func loadData()
}

