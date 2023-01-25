//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Иван Иванов on 08.01.2023.
//

import Foundation

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
