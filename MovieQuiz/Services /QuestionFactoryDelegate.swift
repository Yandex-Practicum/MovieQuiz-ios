//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Daud Tsechoev on 23.04.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // функ об успеш загрузке сообщ
    func didFailToLoadData(with error: Error) // функ об ошибке загрузки сообщ 
}
