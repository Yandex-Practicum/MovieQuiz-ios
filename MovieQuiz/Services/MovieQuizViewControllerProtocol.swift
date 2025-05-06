//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Рамиль Аглямов on 29.04.2023.
//

import Foundation
protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
//    func show(quiz result: QuizResultsViewModel)
    func printAlert (alertModel: AlertModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
   
}
