//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Дмитрий Редька on 26.11.2022.
//

import Foundation
protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
    func loadData()
}
