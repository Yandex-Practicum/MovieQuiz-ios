//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Дмитрий on 08.02.2024.
//

import Foundation

protocol QuestionFactoryProtocol {
    
    var delegate: QuestionFactoryDelegate? { get set }
    
    func requestNextQuestion()
}
