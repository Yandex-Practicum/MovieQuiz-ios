//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Дмитрий Калько on 12.09.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    
    var delegate: QuestionFactoryDelegate? { get set }
    
    func requestNextQuestion()
}
