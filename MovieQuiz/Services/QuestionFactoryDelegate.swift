//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by  Игорь Килеев on 02.09.2023.
//

import Foundation


protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
