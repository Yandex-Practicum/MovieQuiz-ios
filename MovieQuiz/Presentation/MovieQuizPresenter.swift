//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Кирилл Марьясов on 16.03.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    
    // MARK: - Переменные и константы
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    // MARK: - Method "IsLastQuestion"
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex >= questionsAmount - 1
    }
    
    // MARK: - Method "ResetQuestionIndex"
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    // MARK: - Method "IsLastQuestion"
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    // MARK: - Method "Convert"
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    // MARK: - Button Yes
    
    func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = true
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Button No
    
    func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }

        let givenAnswer = false

        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
}
