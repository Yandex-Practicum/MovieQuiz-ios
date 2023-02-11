//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 04.02.2023.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
