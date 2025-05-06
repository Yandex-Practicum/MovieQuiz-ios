//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by admin on 28.12.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}
