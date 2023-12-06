//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Fedor on 14.11.2023.
//

import Foundation

//Моки данные для заполнения массива вопросов квиза
private var theGodfather = QuizQuestion(image: "The Godfather", text: "Рейтин этого фильма больше чем 6?", correctAnswer: true)

private var theDarkKnight = QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

private var killBill = QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

private var theAvengers = QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

private var deadpool = QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

private var theGreenKnight = QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

private var old = QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)

private var theIceAgeAdvanturesOfBuckWild = QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)

private var tesla = QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)

private var vivarium = QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)

class QuestionFactory: QuestionFactoryProtocol {
    
    private let questions: [QuizQuestion] = [theGodfather, theDarkKnight, killBill, theAvengers, deadpool, theGreenKnight, old, theIceAgeAdvanturesOfBuckWild, tesla, vivarium]
    
    //Определяем делегата для фабрики вопросов
    private let movieLoader: MoviesLoaderProtocol
    weak var delegate: QuestionFactoryDelegatePrototocol?
    private var movies: [MostPopularMovie] = []
    
    init(movieLoader: MoviesLoaderProtocol, delegate: QuestionFactoryDelegatePrototocol? = nil) {
        self.movieLoader = movieLoader
        self.delegate = delegate
    }
    
    func requestNextQuestion() {

        //выбираем случайный элемент QuizeQuestion из массива вопросов по индексу элемента
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didFinishReceiveQuestion(question: nil)
            return }
        
        let question = questions[safe: index]
        
        //Передаем структуру QuizQuestion делегату
        delegate?.didFinishReceiveQuestion(question: question)
    }
}
