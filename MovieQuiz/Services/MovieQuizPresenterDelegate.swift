//
//  MovieQuizPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Alexey on 12.02.2023.
//

import UIKit

protocol MovieQuizPresenterDelegate: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func highlightImageBorder(isCorrect: Bool)
    func show(quiz: QuizStepViewModel)
    func presentController(_ controller: UIViewController, animated: Bool)
    func setButtons(enable: Bool)
    func show(result: AlertModel)
}
