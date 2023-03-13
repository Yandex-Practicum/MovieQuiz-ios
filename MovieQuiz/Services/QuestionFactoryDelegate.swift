//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Видич Анна  on 25.2.23..
//

import Foundation

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
