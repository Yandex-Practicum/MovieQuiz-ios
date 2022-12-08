//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Ruslan Batalov on 08.11.2022.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
       
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
        init(moviesLoader: MoviesLoading,delegate: QuestionFactoryDelegate?) {
            self.moviesLoader = moviesLoader
            self.delegate = delegate
        }
    func loadData() {
        moviesLoader.loadMovies { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    
                    if mostPopularMovies.errorMessage.isEmpty == true{
                        self.movies = mostPopularMovies.items
                        self.delegate?.didLoadDataFromServer() }
                                           
                    case .failure(let error):
                        self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
       
    private weak var delegate: QuestionFactoryDelegate?
        
    func requestNextQuestion() {
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
                                         correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didRecieveNextQuestion(question: question)
            }
        }
    }         
}


