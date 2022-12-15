//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Григорий Сухотин on 15.12.2022.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func hideLoadingIndicator()
    func showLoadingIndicator()
    func showNetworkError(message: String)
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    func resetAnwserResult()
    func highlightBorders(isCorrect: Bool)
    func enableAnswerButtons()
    func disableAnswerButtons()
}
