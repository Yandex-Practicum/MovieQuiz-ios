//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Роман Бойко on 10/16/22.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    let moviesLoader: MoviesLoading?
    
    weak var delegate: QuestionFactoryDelegate?
    
    var movies: [MostPopularMovie] = []
    // Функция формирования следующего вопроса
    func requestNextQuestion () {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            // Создаём случайный индекс в диапазоне длины массива
            let index = (0..<self.movies.count).randomElement() ?? 0
            // Создаём экземпляр MostPopularMovie
            guard let movie = self.movies[safe: index] else { return }
            // Получаем постер фильма
            var imageData = Data()
            do {
                    imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch let error{
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didFailToLoadData(with: error)
                }
                print("Failed to download image")
            }
            // Получаем рейтинг фильма
            let rating = Float(movie.rating) ?? 0
            // Придумываем случайное число для сравнения с рейтингом
            let randomRating = Int.random(in: 7...9)
            // Формируем вопрос для пользователя
            let text = "Рейтинг этого фильма больше чем \(randomRating)?"
            // Определяем верный ответ
            let correctAnswer = rating > Float(randomRating)
            // Формируем вопрос
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                // Передаём вопрос делегату
                    self.delegate?.didReciveNextQuestion(question: question)
            }
        }
    }
    
    func loadData() {
        guard let moviesLoader = moviesLoader else { return }
        moviesLoader.loadMovies() { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didloadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    init(moviesLoader: MoviesLoading?, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    /*private var questions: [QuizQuestion] {
     [ QuizQuestion(
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
     correctAnswer: true),
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
     correctAnswer: false)]
     }
     */
}
