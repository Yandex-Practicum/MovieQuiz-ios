//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by admin on 28.12.2023.
//

import Foundation


protocol QuestionFactoryProtocol: AnyObject {
    
    var delegate: QuestionFactoryDelegate? { get set }
    
    func requestNextQuestion()
}
