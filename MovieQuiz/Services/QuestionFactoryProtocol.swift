//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Александр Сироткин on 26.11.2022.
//

import Foundation

protocol QuestionFactoryProtocol {

    func requestNextQuestion() -> QuizQuestion?

}
