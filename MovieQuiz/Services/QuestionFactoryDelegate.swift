//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Рамиль Аглямов on 13.04.2023.
//

import Foundation

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error) 
}
