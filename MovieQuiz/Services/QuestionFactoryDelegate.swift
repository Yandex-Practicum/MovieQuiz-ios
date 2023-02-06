//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Влад on 12.01.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
