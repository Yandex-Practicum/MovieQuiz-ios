//
//  QuestionFactory.swift
//  MovieQuiz

import Foundation
final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
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
        let listOfQuestions = [
            "Рейтинг этого фильма больше чем 7?",
            "Рейтинг этого фильма больше чем 8?",
            "Рейтинг этого фильма больше чем 9?",
            "Рейтинг этого фильма меньше чем 9?",
            "Рейтинг этого фильма меньше чем 8?",
            "Рейтинг этого фильма меньше чем 7?"]
        let indexOfQuestion = (0...5).randomElement() ?? 0
        let text = listOfQuestions[indexOfQuestion]
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
            let correctAnswer: Bool
            switch indexOfQuestion {
            case 1: correctAnswer = rating > 8
            case 2: correctAnswer = rating > 9
            case 3: correctAnswer = rating < 9
            case 4: correctAnswer = rating < 8
            case 5: correctAnswer = rating < 7
            default: correctAnswer = rating > 7
            }
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}

