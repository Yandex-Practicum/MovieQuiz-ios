//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Dmitrii on 15.05.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
