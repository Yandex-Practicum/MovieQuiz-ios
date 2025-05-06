//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Рамиль Аглямов on 13.04.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)    
}
