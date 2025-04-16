//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Роман Ивановский on 06.07.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}

