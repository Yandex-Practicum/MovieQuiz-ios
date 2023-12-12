
import Foundation

class QuestionFactory:QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    private var movies: [MostPopularMovie] = []
    
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
        DispatchQueue.global().async { [weak self] in
            guard let self, let movie = self.movies.randomElement() else { return }
            do {
                let imageData = try Data(contentsOf: movie.resizedImageURL)
                let rating = Float(movie.rating) ?? 0
                let ratingQuestion = Float.random(in: 7.9..<9.4)
                let text = String(format: "Рейтинг этого фильма больше чем %.1f?", ratingQuestion)
                let correctAnswer = rating > ratingQuestion
                let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    guard let self else { return }
                    self.delegate?.didReceiveNextQuestion(question: question)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.delegate?.didFailNextQuestion(with: error)
                }
            }
        }
    }
    
}
