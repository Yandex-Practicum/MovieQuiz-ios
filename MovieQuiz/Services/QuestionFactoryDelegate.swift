//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Alexey Ponomarev on 18.04.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
