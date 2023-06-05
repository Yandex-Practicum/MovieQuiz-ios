//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Admin on 20.05.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(_ question: QuizQuestion?)
}
