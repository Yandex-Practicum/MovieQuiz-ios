//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Toto Tsipun on 08.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
