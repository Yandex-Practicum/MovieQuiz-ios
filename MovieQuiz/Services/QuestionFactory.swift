//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Sergey Telnov on 20/10/2023.
//

import Foundation
import UIKit

final class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    //    private let questions: [QuizQuestion] = [
    //        QuizQuestion(filmName: "The Godfather", rating: 9.2, text: "Рейтинг этого фильма больше чем 6?", answer: true),
    //        QuizQuestion(filmName: "The Dark Knight", rating: 8.1, text: "Рейтинг этого фильма больше чем 6?", answer: true),
    //        QuizQuestion(filmName: "Kill Bill", rating: 8.1, text: "Рейтинг этого фильма больше чем 6?", answer: true),
    //        QuizQuestion(filmName: "The Avengers", rating: 8.0, text: "Рейтинг этого фильма больше чем 6?", answer: true),
    //        QuizQuestion(filmName: "Deadpool", rating: 8.0, text: "Рейтинг этого фильма больше чем 6?", answer: true),
    //        QuizQuestion(filmName: "The Green Knight", rating: 6.6, text: "Рейтинг этого фильма больше чем 6?", answer: true),
    //        QuizQuestion(filmName: "Old", rating: 5.8, text: "Рейтинг этого фильма больше чем 6?", answer: false),
    //        QuizQuestion(filmName: "The Ice Age Adventures of Buck Wild", rating: 4.3, text: "Рейтинг этого фильма больше чем 6?", answer: false),
    //        QuizQuestion(filmName: "Tesla", rating: 5.1, text: "Рейтинг этого фильма больше чем 6?", answer: false),
    //        QuizQuestion(filmName: "Vivarium", rating: 5.8, text: "Рейтинг этого фильма больше чем 6?", answer: false)
    //    ]
    
    func requestNextQuestion() {
        //        guard let index = (0..<questions.count).randomElement() else
        //        { delegate?.didReceiveNextQuestion(question: nil)
        //            return
        //        }
        //        delegate?.didReceiveNextQuestion(question: questions[safe: index])
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        answer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
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
