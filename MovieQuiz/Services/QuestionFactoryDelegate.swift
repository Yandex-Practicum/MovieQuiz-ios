//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Дмитрий on 09.02.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
