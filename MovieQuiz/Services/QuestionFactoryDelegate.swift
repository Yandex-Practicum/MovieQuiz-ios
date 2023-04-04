//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Василий on 11.06.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}
