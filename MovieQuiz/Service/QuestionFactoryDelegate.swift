//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Ярослав Калмыков on 14.12.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
