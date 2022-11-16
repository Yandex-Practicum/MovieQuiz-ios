//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Илья Тимченко on 17.10.2022.
//

import Foundation
import UIKit

struct ResultAlertPresenter {
    weak var delegate: MovieQuizViewController?
    
    init (delegate: MovieQuizViewController) {
        self.delegate = delegate
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            delegate?.currentQuestionIndex = 0
            delegate?.correctAnswers = 0
            delegate?.questionFactory?.requestNewQuestions()
        }
        alert.view.accessibilityIdentifier = "Alert"
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
