//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Мария Авдеева on 16.01.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String, alertPresenter: AlertPresenter)

} 
