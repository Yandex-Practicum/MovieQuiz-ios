//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by  admin on 17.08.2022.
//

import Foundation
protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizeQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
