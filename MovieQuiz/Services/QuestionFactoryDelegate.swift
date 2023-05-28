//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Alexey Tsidilin on 26.10.2022.
//

import Foundation

protocol QuestionFactoryDelegate: class {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
