//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Даниил Романов on 04.03.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
