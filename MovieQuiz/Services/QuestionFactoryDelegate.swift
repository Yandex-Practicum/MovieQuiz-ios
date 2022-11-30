//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Алексей on 27.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
