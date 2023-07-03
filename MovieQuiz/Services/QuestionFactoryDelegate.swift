//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Bogdan Fartdinov on 13.06.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadFromServer() // данные успешно загрузились
    func didFailToLoadData(with error: Error) // ошибка загрузки с сервера
}
