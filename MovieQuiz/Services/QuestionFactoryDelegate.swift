//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Ivan on 12.07.2023.
//

import Foundation

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
