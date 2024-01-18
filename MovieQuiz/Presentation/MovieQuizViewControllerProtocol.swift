//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Sergey Ivanov on 16.01.2024.
//
//

import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showQuestionAnswerResult(isCorrect: Bool)
    func showQuizResults(model: AlertModel?)
    func showNetworkError(message: String)
    func showQuestion(quiz step: QuizStepViewModel)
    func setAnswerButtonsEnabled(_ enabled: Bool)
}
