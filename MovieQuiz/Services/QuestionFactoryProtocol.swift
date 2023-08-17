//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 19.07.2023.
//

import Foundation

protocol QuestionFactoryProtocol: QuestionFactory {
    
    func requestNextQuestion()
    func loadData()
}
