//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Илья Дышлюк on 14.02.2024.
//

import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    func isLastQuistion() -> Bool{
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuistionIndex(){
        currentQuestionIndex = 0
    }
    
    func switchToNextQuistion(){
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}
