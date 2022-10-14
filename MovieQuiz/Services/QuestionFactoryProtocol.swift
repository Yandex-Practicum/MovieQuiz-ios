//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Andrey Sysoev on 29.09.2022.
//

import Foundation

protocol QuestionFactoryProtocol {
    func loadData()
    func requestNextQuestion()
}
