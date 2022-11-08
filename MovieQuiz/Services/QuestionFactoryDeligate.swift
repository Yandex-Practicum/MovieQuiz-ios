//
//  QuestionFactoryDeligate.swift
//  MovieQuiz
//
//  Created by Роман Бойко on 10/18/22.
//

import Foundation

protocol QuestionFactoryDelegate: class {
    func didReciveNextQuestion (question: QuizQuestion?)
    func didloadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error)
}
