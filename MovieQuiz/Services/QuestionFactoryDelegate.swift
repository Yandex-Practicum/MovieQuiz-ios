//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Konstantin Zuykov on 08.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate : AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
