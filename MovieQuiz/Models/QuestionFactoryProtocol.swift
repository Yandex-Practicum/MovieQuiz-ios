//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Марина Писарева on 17.12.2022.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
}
