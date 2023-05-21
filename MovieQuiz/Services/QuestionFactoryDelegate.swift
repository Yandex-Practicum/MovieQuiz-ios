//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Nikolay Kozlov on 21.05.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReciveNextQuestion(question: QuizQuestion?)
}
