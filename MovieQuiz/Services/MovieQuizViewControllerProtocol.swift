//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Андрей Манкевич on 01.05.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
   
    func show(quiz step: QuizStepViewModel)
    
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
   
}
