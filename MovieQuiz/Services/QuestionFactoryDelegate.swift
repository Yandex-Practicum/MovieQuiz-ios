//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Арсений Убский on 21.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: class {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
