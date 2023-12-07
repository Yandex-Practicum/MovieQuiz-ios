//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Fedor on 15.11.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    
    var delegate: QuestionFactoryDelegatePrototocol? { get set }
    
    func requestNextQuestion() -> Void
    
    func loadData() -> Void
    
}
