//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Глеб Хамин on 09.10.2023.
//

import Foundation

protocol QuestionFactory {
    func requestNextQuestion()
    func loadData()
}
