//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Анатолий Труфанов on 21.03.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
    
    

