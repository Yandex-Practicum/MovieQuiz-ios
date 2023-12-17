//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Sergey Ivanov on 17.12.2023.
//

import UIKit

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
