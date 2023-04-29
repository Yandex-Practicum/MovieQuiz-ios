//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Sergey Popkov on 11.04.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               
    func didReceiveNextQuestion(question: QuizQuestion?)
}
