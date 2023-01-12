//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Андрей Парамонов on 10.01.2023.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    private var currentIndex = -1
    private var movies: [MostPopularMovie] = []
    private var totalQuestions: Int {
        movies.count
    }

    init(delegate: QuestionFactoryDelegate, moviesLoader: MoviesLoading) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }

    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else {
                    return
                };
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }

    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else {
                return
            }
            let index = self.generateNext()
            guard let movie = self.movies[safe: index] else {
                return
            }
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            let rating = Float(movie.rating) ?? 0
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
            let question = QuizQuestion(
                    image: imageData,
                    text: text,
                    correctAnswer: correctAnswer)
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }

    private func generateNext() -> Int {
        var index: Int?
        repeat {
            index = (0..<totalQuestions).randomElement()
        } while (index == nil || index == currentIndex)
        return index ?? 0
    }

//    func requestNextQuestion() {
//        current = generateNext()
//        let question = questions[safe: current]
//        delegate?.didReceiveNextQuestion(question: question)
//    }
//
//
//    private let questions: [QuizQuestion] = [
//        QuizQuestion(
//                image: "The Godfather",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//        QuizQuestion(
//                image: "The Dark Knight",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//        QuizQuestion(
//                image: "Kill Bill",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//        QuizQuestion(
//                image: "The Avengers",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//        QuizQuestion(
//                image: "Deadpool",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//        QuizQuestion(
//                image: "The Green Knight",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//        QuizQuestion(
//                image: "Old",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: false),
//        QuizQuestion(
//                image: "The Ice Age Adventures of Buck Wild",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: false),
//        QuizQuestion(
//                image: "Tesla",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: false),
//        QuizQuestion(
//                image: "Vivarium",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: false)
//    ]
}
