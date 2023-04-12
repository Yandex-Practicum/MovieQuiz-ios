//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Mir on 18.03.2023.
//

import UIKit

final class QuestionFactory: QuestionFactoryProtocol {
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    
    init(delegate: QuestionFactoryDelegate, moviesLoader: MoviesLoading) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }

    func loadData() {
        moviesLoader.loadMovies { [ weak self ] result in
            DispatchQueue.main.async { [ weak self ] in
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
        DispatchQueue.global().async { [ weak self ] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async { [ weak self ] in
                    self?.delegate?.didFailToLoadImage()
                }
                print("Failed to load image")
            }
            
            let randomRating = Float.random(in: 6...9)
            let rating = Float(movie.rating) ?? 0
            
            let text = "Рейтинг этого фильма \nбольше чем \(Int(randomRating))?"
            let correctAnswer = rating > randomRating
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [ weak self ] in
                guard let self = self else { return }
                self.delegate?.didRecieveNextQuestion(question: question)
            }
        }
    }
}
