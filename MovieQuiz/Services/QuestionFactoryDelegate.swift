//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Mikhail Vostrikov on 26.05.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveQuestion(_ question: QuizQuestion)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
