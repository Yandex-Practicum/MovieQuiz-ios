//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Илья Тимченко on 16.11.2022.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
        func show(quiz result: QuizResultsViewModel)
        func highlightImageBorder(isCorrectAnswer: Bool)
        func showLoadingIndicator()
        func hideLoadingIndicator()
        func showNetworkError(message: String)
}
