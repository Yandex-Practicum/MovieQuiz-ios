//
//  AlertDelegate.swift
//  MovieQuiz
//
//  Created by Yerman Ibragimuly on 29.02.2024.
//

import Foundation

protocol AlertDelegate: AnyObject {
    func show(quiz result: QuizResultsViewModel)
}
