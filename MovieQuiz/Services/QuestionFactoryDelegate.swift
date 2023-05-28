//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Эльдар Айдумов on 20.05.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion (question: QuizQuestion?)
}
