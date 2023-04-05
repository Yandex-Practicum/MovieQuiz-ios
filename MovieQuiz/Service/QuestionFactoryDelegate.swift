//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Ольга Чушева on 19.03.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
