//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Илья Дышлюк on 30.11.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}



