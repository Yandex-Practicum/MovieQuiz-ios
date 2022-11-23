import UIKit

class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoadingProtocol
    private let networkClient = NetworkClient()
    
    init(moviesLoader: MoviesLoadingProtocol) {
        self.moviesLoader = moviesLoader
    }
    
    private var movies: [OneMovie] = []
    private var quizQuestions: [QuizQuestion] = []

    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies
                    self.delegate?.didLoadDataFromServer()
                    
                case .failure(let error):
                    self.delegate?.didFailToLoadDataFromServer(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        
        let index = (0..<self.movies.count).randomElement() ?? 0
        guard let question = self.movies[safe: index] else { return }
        let randomNumber = Double.random(in: 5.0...9.1)
        let correctAnswer = (question.rating > randomNumber)
        let text = "Рейтинг этого фильма больше чем \(Int(randomNumber))?"
        
        networkClient.fetch(url: question.resizedImageURL) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success(let data):
                    let quizQuestion = QuizQuestion(image: data,
                                                    text: text,
                                                    correctAnswer: correctAnswer)
                    
                    self.delegate?.didReceiveNextQuestion(question: quizQuestion)
                case .failure(let error):
                    self.delegate?.didFailToLoadImageFromServer(with: error)
                }
            }
        }
    }
}

