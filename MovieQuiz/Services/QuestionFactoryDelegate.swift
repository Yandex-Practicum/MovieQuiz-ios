//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Видич Анна  on 25.2.23..
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
