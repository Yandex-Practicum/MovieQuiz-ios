import UIKit

class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
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
            
            let randomRating = Float.random(in: 7.0...9.9)
            let isGreaterThan = Bool.random()
            let text = "Рейтинг этого фильма \(isGreaterThan ? "больше" : "меньше") чем \(String(format: "%.1f", randomRating))?"
            
            let movieRating = Float(movie.rating) ?? 0
            let correctAnswer = isGreaterThan ? (movieRating > randomRating) : (movieRating < randomRating)
            
            
            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case.success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case.failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
}
