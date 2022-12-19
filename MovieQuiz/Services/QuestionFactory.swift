

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    private enum ServerError: Error {
        case custom(description: String)
    }
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    weak var delegate: QuestionFactoryDelegate?
    
    func loadData() {
        moviesLoader.loadMovies() { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success(let mostPopularMovies):
                    if mostPopularMovies.errorMessage.isEmpty {
                        self.movies = mostPopularMovies.items
                        self.delegate?.didLoadDataFromServer()
                    } else {
                        let error = ServerError.custom(description: mostPopularMovies.errorMessage)
                        self.delegate?.didFailToLoadData(with: error)
                    }
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)

                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else {return}
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            let rating = Float(movie.rating) ?? 0
            let ratingForQuestion = (5...7).randomElement() ?? 7
            let text = "Рейтинг этого фильма больше, чем \(ratingForQuestion)"
            let correctAnswer = rating > Float(ratingForQuestion)
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.delegate?.didRecieveNextQuestion(question: question)
                
            }
        }
    }
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
}
