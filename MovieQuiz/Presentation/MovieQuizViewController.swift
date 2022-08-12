// swiftlint:disable all

import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
    }
    
    
    // MARK: - СОСТОЯНИЯ
    
    // Структура — "Вопрос задан"
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questuinNumber: String
    }
    
    // Структура — "Результат квиза"
    struct QuizResultViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
 
    // Состояние «Результат ответа» можно описать одной переменной типа Bool — ответ правильный или нет.
    
    // MARK: - ДАННЫЕ
    
    // Структура данных отдельного вопроса
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    // Массив вопросов
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
}



// MARK: - РАСШИРЕНИЯ КЛАССОВ

// Цвета
extension UIColor {
    static var ypBlack: UIColor { UIColor(named: "YP Black") ?? UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1) }
    static var ypWhite: UIColor { UIColor(named: "YP White") ?? UIColor(red: 1, green: 1, blue: 1, alpha: 1) }
    static var ypGreen: UIColor { UIColor(named: "YP Green") ?? UIColor(red: 0.376, green: 0.761, blue: 0.557, alpha: 1) }
    static var ypRed: UIColor { UIColor(named: "YP Red") ?? UIColor(red: 0.961, green: 0.42, blue: 0.34, alpha: 1) }
    static var ypGray: UIColor { UIColor(named: "YP Gray") ?? UIColor(red: 0.26, green: 0.27, blue: 0.133, alpha: 1) }
    static var ypBackground: UIColor { UIColor(named: "YP Background") ?? UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0.6) }
}
