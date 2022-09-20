import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private let delegate: QuestionFactoryDelegate
    init( moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }

    private var movies: [MostPopularMovie] = []

    func requestNextQuestion() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.delegate.didRequestNextQuestion()
        }
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0

            guard let movie = self.movies[safe: index] else { return }

            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.imageURL)
            } catch {
                print("Failed to load image")
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate.didReceiveNextQuestion(question: nil)
                }
            }

            let rating = Float(movie.rating) ?? 0
            let random = Int.random(in: 5..<8)
            let text = "Рейтинг этого фильма больше чем \(random)?"
            let correctAnswer = rating > Float(random)

            let question = QuizQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer)

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate.didReceiveNextQuestion(question: question)
            }
        }
    }
    func loadData() {
          moviesLoader.loadMovies { [weak self] result in
              guard let self = self else { return }
              switch result {
              case .success(let mostPopularMovies):
                  DispatchQueue.main.async {
                      self.movies = mostPopularMovies.items
                      self.delegate.didLoadDataFromServer()
                  }

              case .failure(let error):
                  DispatchQueue.main.async {
                      self.delegate.didFailToLoadData(with: error)
                  }
              }
          }
      }
}
