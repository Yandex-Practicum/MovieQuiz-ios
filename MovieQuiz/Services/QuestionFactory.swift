//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Mikhail Vostrikov on 08.04.2023.
//
 
import Foundation

    //MARK: -  Protocol

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveQuestion(_ question: QuizQuestion)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}

protocol QuestionFactory {
    func requestNextQuestion()
    func loadData ()
}

final class QuestionFactoryImpl: QuestionFactory {
    
    //MARK: - Properties
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    // MARK: - Init
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    
    //MARK: -
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    DispatchQueue.main.async {
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.delegate?.didFailToLoadData(with: error)
                    }
                }
            }
        }
    }
}
    
    extension QuestionFactoryImpl {
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
                
                let rating = Float(Int.random(in: 1...10))
                
                let text = "Рейтинг этого фильма больше чем 7?"
                let correctAnswer = rating > 7
                
                let question = QuizQuestion(image: imageData,
                                            text: text,
                                            correctAnswer: correctAnswer)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didReceiveQuestion(question)
                }
            }
        }
    }

    
    /*
     //MARK: - Enum
     
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
     correctAnswer: true),
     
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
     correctAnswer: false)
     ]
     */
    

