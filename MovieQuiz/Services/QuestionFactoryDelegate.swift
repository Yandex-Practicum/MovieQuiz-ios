//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Ольга Лазарчик on 1.12.22.
//

import Foundation

protocol QuestionFactoryDelegate: class {
    func didRecieveNextQuestion (question: QuizQuestion?)
}
