//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Aleksey Shaposhnikov on 24.04.2023.
//

import Foundation


class QuestionFactory: QuestionFactoryProtocol {
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading

    private var movies: [MostPopularMovie] = []

    private enum OperationTypes: String, CaseIterable {
        case more = "больше"
        case less = "меньше"
    }

    init(delegate: QuestionFactoryDelegate, moviesLoader: MoviesLoading) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }

    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
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
            guard let self = self else { return }

            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }

            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    imageData = Data()
                    self.delegate?.didFailToLoadData(with: error)
                }
            }

            let ratingIMDb = Float(movie.rating) ?? 0

            let roundRating = round(ratingIMDb)                         // округляем рейтинг для упрощения расчетов
            let rating = self.randomRating(rating: roundRating)
            guard let operationType = OperationTypes.allCases.randomElement() else { return }

            var correctAnswer: Bool {
                switch operationType {
                case .more:
                    return ratingIMDb > Float(rating)
                case .less:
                    return ratingIMDb < Float(rating)
                }
            }

            let text = "Рейтинг этого фильма \(operationType.rawValue) чем \(rating)?"

            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }

    private func randomRating(rating: Float) -> Int {
        var randomRating: Int
        switch rating {
        case 10.0:
            randomRating = (1...9).randomElement() ?? 0
        case 0.0, 1.0:
            randomRating = (2...10).randomElement() ?? 0
        default:
            if Bool.random() {
                randomRating = Int(rating) + 1
            } else {
                randomRating = Int(rating) - 1
            }
            if randomRating >= 10 || randomRating <= 1 {
                randomRating = Int(rating)
            }
        }
        return randomRating
    }

//    func requestNextQuestion() {
//        guard let index = (0..<questions.count).randomElement() else {
//            delegate?.didReceiveNextQuestion(question: nil)
//            return
//        }
//        let question = questions[safe: index]
//        delegate?.didReceiveNextQuestion(question: question)
//    }
//
//    private let questions: [QuizQuestion] = [
//            QuizQuestion(
//                image: "The Godfather",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//            QuizQuestion(
//                image: "The Dark Knight",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//            QuizQuestion(
//                image: "Kill Bill",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//            QuizQuestion(
//                image: "The Avengers",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//            QuizQuestion(
//                image: "Deadpool",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//            QuizQuestion(
//                image: "The Green Knight",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//            QuizQuestion(
//                image: "Old",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: false),
//            QuizQuestion(
//                image: "The Ice Age Adventures of Buck Wild",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: false),
//            QuizQuestion(
//                image: "Tesla",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: false),
//            QuizQuestion(
//                image: "Vivarium",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: false)
//        ]
}
