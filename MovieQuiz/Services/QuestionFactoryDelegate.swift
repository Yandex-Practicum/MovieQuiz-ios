//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Рамиль Аглямов on 13.04.2023.
//

import Foundation

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
