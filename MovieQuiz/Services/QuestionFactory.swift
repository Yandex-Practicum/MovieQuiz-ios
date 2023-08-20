//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 26.07.2023.
//
import UIKit

class QuestionFactory: QuestionFactoryProtocol {
    func resetData() {
        loadData()
    }
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate? = nil) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    private var movies: [MostPopularMovie] = []
    // Метод, который использует moviesLoader для загрузки данных о популярных фильмах
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
    // Метод который генерирует случайный вопрос о фильме
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            // Генерируем случайный рейтинг для каждого фильма
            let minRating: Float = 3.0
            let maxRating: Float = 9.0
            let randomRating = Float.random(in: minRating...maxRating)
            
            if let imageData = try? Data(contentsOf: movie.resizedImageURL),
               let _ = UIImage(data: imageData) {
                let rating = Float(movie.rating) ?? 0
                let roundedRandomRating = Int(randomRating)
                let text = "Рейтинг этого фильма \(randomRating > rating ? "больше" : "меньше") чем \(roundedRandomRating)?"
                let correctAnswer = randomRating > rating
                let question = QuizQuestion(image: imageData,
                                            text: text,
                                            correctAnswer: correctAnswer)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didReceiveNextQuestion(question: question)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let errorMessage = "Не удалось загрузить изображение фильма. Попробуйте еще раз."
                    self.delegate?.didFailToLoadData(with: NSError(domain: "QuestionFactoryError", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                }
            }
        }
    }
}
