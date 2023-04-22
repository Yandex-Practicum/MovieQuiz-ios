//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Kuimova Olga on 19.04.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
