//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Ruslan Batalov on 09.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: class {
    
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
        func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
