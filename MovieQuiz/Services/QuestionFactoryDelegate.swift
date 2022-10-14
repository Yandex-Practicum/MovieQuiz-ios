//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by macOS on 30.09.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
