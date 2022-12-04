//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Alexander Farizanov on 04.12.2022.
//

import Foundation

protocol QuestionFactoryDelegate {                   // 1
    func didRecieveNextQuestion(question: QuizQuestion?)   // 2
}
// class
