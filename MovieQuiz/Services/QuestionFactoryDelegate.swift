//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by tommy tm on 07.12.2022.
//

import Foundation


protocol QuestionFactoryDelegate: AnyObject {                   // 1
    func didRecieveNextQuestion(question: QuizQuestion?)   // 2
}

