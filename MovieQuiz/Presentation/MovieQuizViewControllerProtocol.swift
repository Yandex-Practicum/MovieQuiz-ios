//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Ivan on 16.08.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func hideLoadingIndicator()
    func showLoadingIndicator()
    func showNetworkError(message: String)
    func show(quiz step: QuizStepViewModel)
    func enabledButtons(isEnabled: Bool)
    func highlightImageBorder(isCorrectAnswer: Bool)
    var alertPresenter: AlertPresenterProtocol? { get }
}
