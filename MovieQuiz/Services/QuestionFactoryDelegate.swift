//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Ruslan Batalov on 09.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate {
    
    func didRecieveNextQuestion(question: QuizQuestion?)
}
