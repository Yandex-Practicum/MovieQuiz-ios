//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Sergey Ivanov on 17.12.2023.
//

import UIKit

protocol QuestionFactoryProtocol: AnyObject {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
}
