//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 19.07.2023.
//

import Foundation


final class QuestionFactory: QuestionFactoryProtocol {
    
    private weak var delegate: QuestionFactoryDelegate?
    
    private let moviesLoader: MoviesLoading
    
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            let index = (0..<movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else {return}
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImage)
            } catch {
                print("Faild to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            let questinRating = (1...9).randomElement()
            guard let safeQuestionRating = questinRating else {return}
            let text = "Рейтинг этого фильма больше чем \(safeQuestionRating)?"
            let correctAnswer = rating > Float(safeQuestionRating)
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
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
}
