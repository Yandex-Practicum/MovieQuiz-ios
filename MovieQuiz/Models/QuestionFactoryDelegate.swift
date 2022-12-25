//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Марина Писарева on 17.12.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
