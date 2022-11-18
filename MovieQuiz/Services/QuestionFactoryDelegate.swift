//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Konstantin Zuykov on 08.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
