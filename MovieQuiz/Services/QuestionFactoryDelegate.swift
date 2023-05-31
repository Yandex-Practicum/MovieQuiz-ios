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
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
