//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Алексей on 18.01.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    var alertPresenter: AlertPresenterProtocol? { get }
    func show(quiz step: QuizStepViewModel)
    
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
