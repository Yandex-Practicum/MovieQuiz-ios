//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Fedor on 14.11.2023.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    private var movies: [MostPopularMovie] = []
    var movieLoader: MoviesLoaderProtocol
    weak var delegate: QuestionFactoryDelegatePrototocol?

    init(movieLoader: MoviesLoaderProtocol, delegate: QuestionFactoryDelegatePrototocol) {
        self.movieLoader = movieLoader
        self.delegate = delegate
    }
    
    func loadData() {
        movieLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let data):
                    self.movies = data.items
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
            guard let index  = (0..<self.movies.count).randomElement() else {
                self.delegate?.didFinishReceiveQuestion(question: nil)
                return
            }
            
            var imageData = Data()
            
            guard let movie = self.movies[safe: index] else { return }
            do {
                imageData = try Data(contentsOf: movie.finalImageUrl)
                
            } catch{
                print("Изображение не загружено.")
            }
            
            guard let questionRating = (1...9).randomElement() else { return }
            let randomComparison = Bool.random()
            var text = ""
            let rating: Double = Double(movie.rating) ?? 0
            var correctAnswer = true
            
            if randomComparison == true {
                text = "Рейтинг этого фильма больше, чем \(questionRating)?"
                correctAnswer = rating > Double(questionRating)
                print(text)
            } else {
                text = "Рейтинг этого фильма меньше, чем \(questionRating)?"
                correctAnswer = rating < Double(questionRating)
            }
            
            let question = QuizQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.delegate?.didFinishReceiveQuestion(question: question)
            }
        }
    }
}
