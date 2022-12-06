//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Григорий Сухотин on 19.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
