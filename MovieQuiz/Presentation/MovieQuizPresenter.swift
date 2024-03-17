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
    var correctAnswers: Int = 0
    var questionFactory: QuestionFactoryProtocol?
    
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
    
    // MARK: - Method "DidAnswer"
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    // MARK: - Button Yes
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    // MARK: - Button No
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    // MARK: - Method "DidReceiveNextQuestion"
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Method "ShowNextQuestionOrResults"
    
    func showNextQuestionOrResults() {
            if self.isLastQuestion() {
                let text = "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
                
                let viewModel = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text: text,
                    buttonText: "Сыграть ещё раз")
                    viewController?.show(quiz: viewModel)
            } else {
                self.switchToNextQuestion()
                questionFactory?.requestNextQuestion()
            }
        }
    
}
