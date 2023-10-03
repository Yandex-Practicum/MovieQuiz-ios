//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Кирилл on 30.09.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(_ questionStep: QuizQuestion?)
}
