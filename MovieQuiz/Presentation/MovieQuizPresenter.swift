//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Роман Бойко on 11/14/22.
//

import Foundation

import UIKit

final class MovieQuizPresenter {
    
    // Переменная индекса текущего вопроса
    private var currentQuestionIndex: Int = 0
    
    //Общее колличество вопросов
    let questionsAmount: Int = 10
    
    // Текущий вопрос, который видит пользователь
    var currentQuestion: QuizQuestion?
    
    // Слабая ссылка на M
    weak var viewController: MovieQuizViewController?
    
    // MARK: - Methods
    // Функция сравнения ответа для кнопки "Да" (true) и правильного ответа
        func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // Функция сравнения ответа для кнопки "Нет" (false) и правильного ответа
        func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
        
    // Функция преобразования вопроса в вью модель
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: String("\(currentQuestionIndex + 1)/\(questionsAmount)")
        )
    }
    
    // Фунуция для определения последнего вопроса
    func isLastQuestion () -> Bool {
        return currentQuestionIndex == questionsAmount - 1
    }
    
    // Функция для сброса индекса текущего вопроса
    func resetQuestionIndex () {
        currentQuestionIndex = 0
    }
    
    // Функция для инкрементирования индекса текущего вопроса
    func switchToNextQuestion () {
        currentQuestionIndex += 1
    }
    
}
