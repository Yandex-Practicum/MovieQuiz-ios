//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Артур Коробейников on 30.01.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}

