//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Sergey Telnov on 20/10/2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? {get set}
    func requestNextQuestion()
}
