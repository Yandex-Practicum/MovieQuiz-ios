//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Елена Михайлова on 06.04.2023.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
