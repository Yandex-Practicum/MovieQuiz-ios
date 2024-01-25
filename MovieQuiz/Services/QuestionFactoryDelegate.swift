//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Soslan Dzampaev on 18.01.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
