//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Ivan on 12.07.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}
