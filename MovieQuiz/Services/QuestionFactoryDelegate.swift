//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Veniamin on 13.11.2022.
//

import Foundation

//Создаём протокол QuestionFactoryDelegate, который будем использовать в фабрике как делегата.
protocol QuestionFactoryDelegate: class {                   // 1
    func didReceiveNextQuestion(question: QuizQuestion?)   // 2
} 
