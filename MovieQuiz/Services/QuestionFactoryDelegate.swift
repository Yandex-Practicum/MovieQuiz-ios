//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Глеб Хамин on 25.09.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
