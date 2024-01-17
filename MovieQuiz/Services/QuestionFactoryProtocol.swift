//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Pavel Popov on 13.01.2024.
//

import Foundation

protocol QuestionFactoryProtocol: AnyObject {
    var delegate: QuestionFactoryDelegate? {get set}
    func requestNextQuestion()
}
