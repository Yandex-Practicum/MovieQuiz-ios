
import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    private var movies: [MostPopularMovie] = []
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    
    
    
    //MARK: - init
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    
    
    // MARK: - Func
    
    func loadData() {
        moviesLoader.loadMovies { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDateFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    } 
    
    func requestNextQuestion(){
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.imageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0 // превращаем строку в число
            
            let questionRating = Float.random(in: 7.00...9.50)
            let text = "Рейтинг этого фильма больше \(String(format: "%.2f", questionRating))?"
            let correctAnswer = rating > questionRating
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didRecieveNextQuestion(question: question)
            }
        }
    }
}




//    private let questions: [QuizQuestion] = [
//        QuizQuestion(
//                    image: "The Godfather",
//                    text: "Рейтинг этого фильма больше чем 6?",
//                    correctAnswer: true
//        ),
//        QuizQuestion(
//                    image: "The Dark Knight",
//                    text: "Рейтинг этого фильма больше чем 6?",
//                    correctAnswer: true
//        ),
//        QuizQuestion(
//                    image: "Kill Bill",
//                    text: "Рейтинг этого фильма больше чем 6?",
//                    correctAnswer: true
//        ),
//        QuizQuestion(
//                    image: "The Avengers",
//                    text: "Рейтинг этого фильма больше чем 6?",
//                    correctAnswer: true
//        ),
//        QuizQuestion(
//                    image: "Deadpool",
//                    text: "Рейтинг этого фильма больше чем 6?",
//                    correctAnswer: true
//        ),
//        QuizQuestion(
//                    image: "The Green Knight",
//                    text: "Рейтинг этого фильма больше чем 6?",
//                    correctAnswer: true
//        ),
//        QuizQuestion(
//                    image: "Old",
//                    text: "Рейтинг этого фильма больше чем 6?",
//                    correctAnswer: false
//        ),
//        QuizQuestion(
//                    image: "The Ice Age Adventures of Buck Wild",
//                    text: "Рейтинг этого фильма больше чем 6?",
//                    correctAnswer: false
//        ),
//        QuizQuestion(
//                    image: "Tesla",
//                    text: "Рейтинг этого фильма больше чем 6?",
//                    correctAnswer: false
//        ),
//        QuizQuestion(
//                    image: "Vivarium",
//                    text: "Рейтинг этого фильма больше чем 6?",
//                    correctAnswer: false
//        )
//    ]
