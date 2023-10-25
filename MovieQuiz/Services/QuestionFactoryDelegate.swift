//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Руслан Коршунов on 04.09.23.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
