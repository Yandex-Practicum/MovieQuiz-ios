//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Andrey Sysoev on 29.09.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
