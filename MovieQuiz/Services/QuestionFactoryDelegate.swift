//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Кирилл Брызгунов on 09.10.2022.
//

import Foundation

protocol QuestionFactoryDelegate: class {                  
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
