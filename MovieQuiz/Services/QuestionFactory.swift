import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private let delegate: QuestionFactoryDelegate
    var movies: [PopularMovie] = []
    /*private var questions: [QuizeQuestion] = [
        QuizeQuestion(image: "The Godfather",text: "Рейтинг этого замечательного фильма \"Крестный отец\" больше, чем 6?" ,correctAnswer: true),
        QuizeQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true),
        QuizeQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true),
        QuizeQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true),
        QuizeQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true),
        QuizeQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true),
        QuizeQuestion(image: "Old", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: false),
        QuizeQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: false),
        QuizeQuestion(image: "Tesla", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: false),
        QuizeQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: false)
    ]*/

    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.imageURL)
            } catch {
                print("Failed to load image")
            }
            var rating = Float(movie.rating) ?? 0
            let floorRating = floor(rating)
            /*if rating == floorRating {
                rating -= 0.0001
            }*/
            print(rating)
            let randomBool = Bool.random()
            var compareSign: String
            var correctAnswer: Bool
            if (randomBool) {
                correctAnswer = floorRating >= rating
                compareSign = "больше"
            } else {
                correctAnswer = floorRating <= rating
                compareSign = "меньше"
            }
            let text = "Рейтинг этого фильма \(compareSign) \(String(format: "%.0f", floorRating))"
            let question = QuizeQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer
            )
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate.didReceiveNextQuestion(question: question)
            }
        }
    }

    func loadData() {
        print("QuestionFactory loadData called")
        moviesLoader.loadMovies(handler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.delegate.didFailToLoadData(with: error)
            case .success(let mostPopularMovies):
                print("NetworkClient returned success in closure")
                self.movies = mostPopularMovies.items
                print("self.movies contain \(self.movies.count) films")
                self.delegate.didLoadDataFromServer()
            }
        })
    }

    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
}
