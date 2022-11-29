//
//  MovieQuizViewPresenter.swift
//  MovieQuiz
//
//  Created by Aleksandr Eliseev on 28.11.2022.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    weak var questionFactory: QuestionFactory?
    var correctAnswers: Int = 0
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    func yesButtonClicked() {
        didAnswerYes(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswerYes(isYes: false)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    private func didAnswerYes(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        
        let givenAnswer = isYes
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            viewController?.showFinalAlert()
        } else {
            self.switchtoNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchtoNextQuestion() {
        currentQuestionIndex += 1
    }
    
}
