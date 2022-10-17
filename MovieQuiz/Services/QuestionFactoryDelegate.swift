//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Илья Тимченко on 10.10.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {                   // 1
    func didRecieveNextQuestion(question: QuizQuestion?)   // 2
}
