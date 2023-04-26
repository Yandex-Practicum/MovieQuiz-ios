import UIKit

class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
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
            let randomNumber = (5...9).randomElement() ?? 5
            let anotherRandomNumber = (0...2).randomElement() ?? 0
            var text: String {
                get {
                    switch anotherRandomNumber {
                    case 0: return "Рейтинг этого фильма больше, чем \(randomNumber)?"
                    case 1: return "Рейтинг этого фильма меньше, чем \(randomNumber)?"
                    default: return "Рейтинг этого фильма равен \(randomNumber)?"
                    }
                }
            }
            let correctAnswer: Bool 
            switch anotherRandomNumber {
            case 0: correctAnswer = rating > Float(randomNumber)
            case 1: correctAnswer = rating < Float(randomNumber)
            default: correctAnswer = rating == Float(randomNumber)
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
