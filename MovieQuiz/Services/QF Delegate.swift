//
//  QF Delegate.swift
//  MovieQuiz
//
//  Created by Иван Корнев on 22.11.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
