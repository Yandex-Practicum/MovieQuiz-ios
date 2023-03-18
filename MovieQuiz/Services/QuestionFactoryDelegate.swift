//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Artem Adiev on 07.12.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // Сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // Сообщение об ошибке загрузки
}
