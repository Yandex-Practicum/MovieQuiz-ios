//
//  MovieQuizControllerProtocol.swift
//  MovieQuiz
//
//  Created by Елена Михайлова on 24.04.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showFinalResults()
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(alertModel: AlertModel)
}
