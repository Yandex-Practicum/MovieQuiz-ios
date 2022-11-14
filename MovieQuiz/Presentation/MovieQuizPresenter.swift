//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Роман Бойко on 11/14/22.
//

import Foundation

import UIKit

final class MovieQuizPresenter {
    
    
    private var currentQuestionIndex: Int = 0
    
    let questionsAmount: Int = 10
    // Функция преобразования вопроса в вью модель
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: String("\(currentQuestionIndex + 1)/\(questionsAmount)")
        )
    }
    
    func isLastQuestion () -> Bool {
        return currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex () {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion () {
        currentQuestionIndex += 1
    }
}
