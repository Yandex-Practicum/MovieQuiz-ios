//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Александр Крапивин on 12.05.2024.
//

import UIKit

protocol QuestionFactoryDelegate : AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
