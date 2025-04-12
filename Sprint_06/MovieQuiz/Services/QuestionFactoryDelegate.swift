//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Pavel Popov on 13.01.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
