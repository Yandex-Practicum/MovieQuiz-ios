//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 20.08.2023.
//

import Foundation
protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
    func loadData()
    func resetData()
}
