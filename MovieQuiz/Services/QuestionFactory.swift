//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Veniamin on 11.11.2022.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol { //устанавливаем протокол, в котором содержится метод requestNextQuestion

    weak var delegate: QuestionFactoryDelegate?  //фабрика будет общаться с этим свойством
    //Мало создать фабрику и делегата — нужно как-то сообщить фабрике о делегате.
    
    init(delegate: QuestionFactoryDelegate?) { // тот, кто будет инициализировать фабрику должен будет указать ее делегата
        self.delegate = delegate
    } 
    
    // MARK: исходные данные
    private let questions: [QuizQuestion] = [
                                     QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                     QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                     QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                     QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                     QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                     QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                     QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                                     QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                                     QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                                     QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                                     ]
    
    func requestNextQuestion() {                       // 1
        guard let index = (0..<questions.count).randomElement() else {  // 2
            delegate?.didReceiveNextQuestion(question: nil) //отправляем в делегат пустоту
            return
        }
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question) //отправляем в делегат вопрос
    } 
} 
