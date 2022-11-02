//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Слава Шестаков on 02.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)  
}
