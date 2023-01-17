//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Maxim Rustamov on 3.01.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
    func loadData()
}






