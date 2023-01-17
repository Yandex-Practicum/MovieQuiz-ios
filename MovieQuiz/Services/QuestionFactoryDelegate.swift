//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Иван Иванов on 08.01.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
