//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Marina on 13.10.2022.
//

import Foundation

protocol QuestionFactoryDelegate: class {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
