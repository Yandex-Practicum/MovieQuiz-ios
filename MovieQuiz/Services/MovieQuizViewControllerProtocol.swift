//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Артур  Арсланов on 21.01.2024.
//

import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showAlert()
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func chooseIsEnableButtons(_ enabled: Bool)
}
