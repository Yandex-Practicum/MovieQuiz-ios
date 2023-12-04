//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
