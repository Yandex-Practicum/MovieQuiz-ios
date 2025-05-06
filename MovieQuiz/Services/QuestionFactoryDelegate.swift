//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by LERÄ on 12.09.23.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               
    func didReceiveNextQuestion(question: QuizQuestion?)
}
