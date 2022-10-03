//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by macOS on 30.09.2022.
//

import Foundation

protocol QuestionFactoryDelegate: class {
    func didReceiveNextQestion(question: QuizQuestion?)
}
