//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Роман Бойко on 11/15/22.
//

import Foundation


protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func hideLoadingIndicator()
    func showLoadingIndicator()
    func hideImageBoarder ()
    func toggleIsEnablebButtons()
    
    func showNetworkError(message: String)
}
