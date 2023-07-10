//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Андрей Чупрыненко on 09.07.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
