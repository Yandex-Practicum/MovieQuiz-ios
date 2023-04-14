//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Ina on 20/03/2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
