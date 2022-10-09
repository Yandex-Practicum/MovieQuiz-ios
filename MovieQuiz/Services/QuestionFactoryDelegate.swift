//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Кирилл Брызгунов on 09.10.2022.
//

import Foundation

protocol QuestionFactoryDelegate: class {                   // 1
    func didRecieveNextQuestion(question: QuizQuestion?)   // 2
}
