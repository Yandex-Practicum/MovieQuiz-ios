//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Дмитрий Калько on 20.09.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    //сообщение об успешной загрузке
    func didLoadDataFromServer()
    //сообщение об ошибке загрузки
    func didFailToLoadData(with error: Error)
}
