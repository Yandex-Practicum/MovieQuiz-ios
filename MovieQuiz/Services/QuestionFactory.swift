//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Viktoria Lobanova on 30.11.2022.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    private var movies: [MovieData] = []
    
    init(moviesLoader: MoviesLoading) {
        self.moviesLoader = moviesLoader
    }
    
    func loadData() {    // инициализирует загрузку данных
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items// сохраняем фильм в нашу новую переменную
                    self.delegate?.didLoadDataFromServer() // сообщаем, что данные загрузились
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
            var imageData = Data() // по умолчанию у нас будут просто пустые данные
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
                let rating = Float(movie.rating) ?? 0 // превращаем строку в число
                let text = "Рейтинг этого фильма больше, чем 7?"
                let correctAnswer = rating > 7
                let question = QuizQuestion(image: imageData,
                                            text: text,
                                            correctAnswer: correctAnswer)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didRecieveNextQuestion(question: question)
                }
            } catch {
                print("Failed to load image")
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
}

