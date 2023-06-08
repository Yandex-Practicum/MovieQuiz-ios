//
//  QuestionFactoryDalegate.swift
//  MovieQuiz
//
//  Created by Владимир Клевцов on 17.5.23..
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)    // 2
}
