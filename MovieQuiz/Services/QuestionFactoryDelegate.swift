//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Sergey Telnov on 22/10/2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
