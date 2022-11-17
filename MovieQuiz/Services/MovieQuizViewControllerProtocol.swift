//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Marina Kolbina on 15/11/2022.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showAlert(alert: AlertModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
