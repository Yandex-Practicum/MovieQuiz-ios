//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Mikhail Vostrikov on 25.05.2023.
//

import UIKit

import UIKit

final class MovieQuizPresenter {
    let questionsCount: Int = 10
    var currentQuestionIndex: Int = 0
    
    func isLastQuestion() -> Bool {
            currentQuestionIndex == questionsCount - 1
        }
    
    func resetQuestionIndex() {
            currentQuestionIndex = 0
        }
    
    func switchToNextQuestion() {
            currentQuestionIndex += 1
        }
    
     func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsCount)")
    }
    
    var currentQuestion: QuizQuestion?
        weak var viewController: MovieQuizViewController?
        
        func yesButtonClicked() {
            guard let currentQuestion = currentQuestion else {
                return
            }
            
            let givenAnswer = true
            
            viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    func noButtonClicked() {
            guard let currentQuestion = currentQuestion else {
                return
            }
            
            let givenAnswer = false
            
            viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
}
