//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by DANCECOMMANDER on 18.04.2023.
//

import Foundation

// Протокол, который мы будем использовать в фабрике как делегата
// AnyOjbect может представлять экземпляр любого класса
protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
    func didFailToLoadImage(with error: Error, onReloadHandler: (() -> Void)?)
}
