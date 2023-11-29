//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Malik Timurkaev on 18.11.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    
    func didReceiveNextQuestion(question: QuizQuestion?)
}
