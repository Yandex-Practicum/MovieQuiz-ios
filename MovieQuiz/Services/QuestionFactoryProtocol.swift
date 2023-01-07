//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Егор Свистушкин on 06.12.2022.
//

import Foundation

protocol QuestionFactoryProtocol {
    
    var delegate: QuestionFactoryDelegate?  { get set }

    func requestNextQuestion()
}
