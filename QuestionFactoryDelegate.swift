//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Григорий Сухотин on 19.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: class {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
