//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Тимур Мурадов on 02.04.2023.
//

import Foundation


protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)    
}
