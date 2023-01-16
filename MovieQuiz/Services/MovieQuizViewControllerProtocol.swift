//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Мария Авдеева on 16.01.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String, alertPresenter: AlertPresenter)
    func show(quiz step: QuizStepViewModel)
    func removeImageBorder()
    func highlightImageBorder(isCorrectAnswer: Bool)
    func makeButtonsInactive()
    func makeButtonsActive()
} 
