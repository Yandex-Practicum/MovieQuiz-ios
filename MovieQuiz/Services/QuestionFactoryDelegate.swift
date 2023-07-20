//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Mishana on 27.06.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
