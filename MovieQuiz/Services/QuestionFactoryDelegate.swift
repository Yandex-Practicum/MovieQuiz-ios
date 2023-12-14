//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Vladimir Vinageras on 13.12.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
