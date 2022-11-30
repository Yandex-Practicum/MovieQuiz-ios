//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Veniamin on 13.11.2022.
//

import Foundation

//Создаём протокол QuestionFactoryDelegate, который будем использовать в фабрике как делегата.
protocol QuestionFactoryDelegate: class {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() //сообщение об успешной загрузки с сервера
    func didFailToLoadData(with error: Error) //сообщение об ошибки загрузки с сервера
} 
