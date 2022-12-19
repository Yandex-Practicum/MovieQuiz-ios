//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Gennadii Kulikov on 03.12.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
