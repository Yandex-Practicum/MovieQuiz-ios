//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by   apollo on 30.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
