//
//  Structures.swift
//  MovieQuiz
//
//  Created by Эльдар Айдумов on 05.05.2023.
//

import UIKit

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}
