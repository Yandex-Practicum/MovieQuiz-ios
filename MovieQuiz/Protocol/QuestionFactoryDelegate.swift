//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Александр Верповский on 08.02.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject { 
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
