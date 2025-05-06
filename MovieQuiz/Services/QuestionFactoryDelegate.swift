//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Мария Авдеева on 03.12.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() 
    func didFailToLoadData(with error: Error)
}
