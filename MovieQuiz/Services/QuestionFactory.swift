//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Mikhail Frantsuzov on 01.11.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveQuestion(_ question: QuizQuestion)
}

protocol QuestionFactory {
    func requestNextQuestion()
    func updateAvailableQuestions()
}

final class QuestionFactoryImplementation {
    
    // MARK: - Properties
    
    private weak var delegate: QuestionFactoryDelegate?
    private var availableQuestions: [QuizQuestion]
    
    // MARK: - Init
    
    init(delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
        self.availableQuestions = questions
    }
}

extension QuestionFactoryImplementation: QuestionFactory {
    func requestNextQuestion() {
        guard let question = availableQuestions.randomElement() else {
            assertionFailure("No more questions available")
            return
        }
        
        if let index = availableQuestions.firstIndex(of: question) {
            availableQuestions.remove(at: index)
        }
        
        delegate?.didReceiveQuestion(question)
    }
    func updateAvailableQuestions() {
        availableQuestions = questions
    }
}

private let questions: [QuizQuestion] = [
    QuizQuestion(image: "The Godfather",
                 text: "Рейтинг этого фильма больше, чем 9?",
                 correctAnswer: true),
    QuizQuestion(image: "The Dark Knight",
                 text: "Рейтинг этого фильма больше, чем 8?",
                 correctAnswer: true),
    QuizQuestion(image: "Kill Bill",
                 text: "Рейтинг этого фильма меньше, чем 9?",
                 correctAnswer: true),
    QuizQuestion(image: "The Avengers",
                 text: "Рейтинг этого фильма меньше, чем 8?",
                 correctAnswer: false),
    QuizQuestion(image: "Deadpool",
                 text: "Рейтинг этого фильма больше, чем 7?",
                 correctAnswer: true),
    QuizQuestion(image: "The Green Knight",
                 text: "Рейтинг этого фильма меньше, чем 7?",
                 correctAnswer: true),
    QuizQuestion(image: "Old",
                 text: "Рейтинг этого фильма больше, чем 6?",
                 correctAnswer: false),
    QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                 text: "Рейтинг этого фильма меньше, чем 5?",
                 correctAnswer: true),
    QuizQuestion(image: "Tesla",
                 text: "Рейтинг этого фильма больше, чем 6?",
                 correctAnswer: false),
    QuizQuestion(image: "Vivarium",
                 text: "Рейтинг этого фильма больше, чем 5?",
                 correctAnswer: true)
]

