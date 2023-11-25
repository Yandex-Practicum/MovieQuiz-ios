//
//  QF Protocol.swift
//  MovieQuiz
//
//  Created by Иван Корнев on 22.11.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    var delegate: QuestionFactoryDelegate? {get set}
}

