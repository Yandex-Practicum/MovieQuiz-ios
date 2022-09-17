import Foundation
import UIKit
class QuestionFactory: QuestionFactoryProtocol {
    static let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true), //  Настоящий рейтинг: 8
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true), // Настоящий рейтинг: 9
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true),  // Настоящий рейтинг: 9,2
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true), // Настоящий рейтинг: 8,1
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true), // Настоящий рейтинг: 8
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true), //  Настоящий рейтинг: 6,6
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: false), // Настоящий рейтинг: 5,8
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: false), //  Настоящий рейтинг: 4,3
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: false), // Настоящий рейтинг: 5,1
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: false)] //  Настоящий рейтинг: 5,8

    func requestNextQuestion() -> QuizQuestion? { // 1
        let index = (0..<QuestionFactory.questions.count).randomElement() ?? 0 // 2
        return QuestionFactory.questions[safe: index] // 3
    }
}
private let questionFactory: QuestionFactoryProtocol = QuestionFactory()
