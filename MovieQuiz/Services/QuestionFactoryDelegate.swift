//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Александр Сироткин on 29.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {

    func didRecieveNextQuestion(question: QuizQuestion?)

}
