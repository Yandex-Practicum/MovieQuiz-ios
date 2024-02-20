//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Кирилл Марьясов on 19.02.2024.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
}
