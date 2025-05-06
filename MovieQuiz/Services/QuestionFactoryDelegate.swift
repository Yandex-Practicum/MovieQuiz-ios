//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Artem Adiev on 07.12.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
