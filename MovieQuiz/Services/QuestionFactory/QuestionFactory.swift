//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Aleksey Kosov on 22.12.2022.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {

    /*
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
     */
    // Состояние вопрос задан

    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?

    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate? = nil) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }


    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {

                guard let self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items // сохраняем фильм в нашу новую переменную
                    self.delegate?.didLoadDataFromServer()
                    // сообщаем, что данные загрузились
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0

            guard let movie = self.movies[safe: index] else { return }

            var imageData = Data()

            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
             //   print("Failed to load image", error)
                DispatchQueue.main.async {
                    self.delegate?.didFailToLoadData(with: error)
                    return
                }
            }

            let rating = Float(movie.rating) ?? 0
            let ratingForQuestion = Int.random(in: 6...9) // вопросы про рейтинг 6 до 9
            let biggerThenQuestion: Bool = Bool.random()

            var text = ""

            switch biggerThenQuestion {
            case true:
                text = "Рейтинг этого фильма больше чем \(ratingForQuestion)?"
            case false:
                text = "Рейтинг этого фильма меньше чем \(ratingForQuestion)?"
            }

            let correctAnswer = biggerThenQuestion ? (rating > Float(ratingForQuestion)) : (rating < Float(ratingForQuestion))

            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
