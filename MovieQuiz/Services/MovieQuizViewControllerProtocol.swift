//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Mikhail Vostrikov on 27.05.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showFinalResults()
    
    func proceedToNextQuestionOrResults(isCorrect: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
