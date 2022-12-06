import UIKit

class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoadingProtocol
    private let networkClient: NetworkRouting
    
    init(delegate: QuestionFactoryDelegate,
         moviesLoader: MoviesLoadingProtocol = MoviesLoader(),
         networkClient: NetworkRouting = NetworkClient()) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
        self.networkClient = networkClient
    }
    
    private var movies: [OneMovie] = []
    
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
        
        networkClient.fetch(url: question.resizedImageURL) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
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

