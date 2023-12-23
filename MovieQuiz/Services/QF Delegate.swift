//
//  QF Delegate.swift
//  MovieQuiz
//
//  Created by Иван Корнев on 04.12.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
        func didFailToLoadData(with error: Error)
}
