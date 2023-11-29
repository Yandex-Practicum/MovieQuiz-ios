//
//  QuestionFactoryProtocl.swift
//  MovieQuiz
//
//  Created by Malik Timurkaev on 17.11.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    
    func requestNextQuestion()
}
