//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Maxim Rustamov on 4.01.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {                                // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}
