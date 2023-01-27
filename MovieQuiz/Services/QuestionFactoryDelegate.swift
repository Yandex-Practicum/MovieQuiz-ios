//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Келлер Дмитрий on 02.01.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: String)
}
