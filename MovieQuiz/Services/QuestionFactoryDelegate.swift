//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Александр Ершов on 02.12.2022.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {                   
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
} 
