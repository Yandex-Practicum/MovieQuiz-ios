//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Alexey on 10.01.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)    
}
