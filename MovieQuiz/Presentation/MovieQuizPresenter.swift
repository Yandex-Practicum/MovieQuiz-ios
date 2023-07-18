//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Антон Павлов on 18.07.2023.
//

import Foundation
import UIKit

final class MovieQuziPresenter {
    
    private var currentQuestionIndex = 0  // Индекс текущего вопроса
    
    let questionsAmount: Int = 10  // Общее количество вопросов
    
    var currentQuestion: QuizQuestion?  // Текущий вопрос
    weak var viewController: MovieQuizViewController?
    
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    // Конвертирование модели вопроса в модель представления
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    // Обработчик нажатия кнопки "Да"
    func yesButtonClicked() {
            guard let currentQuestion = currentQuestion else {
                return
            }
            
            let givenAnswer = true
            
            viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }

    // Обработчик нажатия кнопки "Нет"
    func noButtonClicked() {
            guard let currentQuestion = currentQuestion else {
                return
            }
            
            let givenAnswer = false
            
            viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
}
