//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Александр Ершов on 02.12.2022.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {                   
    func didRecieveNextQuestion(question: QuizQuestion?)
} 
