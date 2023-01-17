//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Maxim Rustamov on 17.01.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showAlert(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrect: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    func enableButtons()
    
}
