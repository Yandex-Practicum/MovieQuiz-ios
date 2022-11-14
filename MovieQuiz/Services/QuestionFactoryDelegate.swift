//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Aleksandr Eliseev on 29.10.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
