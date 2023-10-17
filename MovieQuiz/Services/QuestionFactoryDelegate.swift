//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Глеб Хамин on 09.10.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(_ question: QuizQuestion)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
