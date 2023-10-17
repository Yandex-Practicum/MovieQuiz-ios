//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Bakhadir on 15.10.2023.
//

import Foundation

protocol QuestionFactory {
    func requestNextQuestion()
    func loadData()
}
