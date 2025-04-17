//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Денис Петров on 17.12.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
} 
