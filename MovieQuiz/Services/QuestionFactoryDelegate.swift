//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Егор Свистушкин on 06.12.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    
    func didReceiveNextQuestion(question: QuizQuestion?) 
}
