//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Леонид Турко on 03.01.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
