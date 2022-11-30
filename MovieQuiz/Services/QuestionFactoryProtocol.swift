//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Veniamin on 13.11.2022.
//

import Foundation

// чтобы не привязываться к конкретному классу QuestionFactory - напишем протокол в котором зададим главное, что характеризует наш класс 0 метод requestNextQuestion()
protocol QuestionFactoryProtocol {
    func requestNextQuestion() // сперва ответ отправлялся сразу, но с появлением делегата это уже не так - вопрос будет отправляться в делегат
    func loadData()
}
