import Foundation

protocol QuestionFactoryDelegate: AnyObject { // Создаём протокол QuestionFactoryDelegate, который будем использовать в фабрике как делегата.
    func didRecieveNextQuestion(question: QuizQuestion?) // Объявляем метод, который должен быть у делегата фабрики.
}
