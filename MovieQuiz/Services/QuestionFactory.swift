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
            let imageURLSeparatedToReceiveName = movie.imageURL.absoluteString.components(separatedBy: "._")
            guard let imageName = imageURLSeparatedToReceiveName[safe: 0] else {
                self.delegate.didReceiveErrorMessage(errorMessage: "Не удалось получить адрес полноразмерного изображения")
                return
            }
            let imageURLSeparatedToReceiveExtension = movie.imageURL.absoluteString.components(separatedBy: ".")
            guard let imageExtension = imageURLSeparatedToReceiveExtension[safe: imageURLSeparatedToReceiveExtension.count - 1] else {
                self.delegate.didReceiveErrorMessage(errorMessage: "Не удалось получить адрес полноразмерного изображения")
                return
            }
            var fullSizeImageUrl: String
            switch imageExtension {
            case "jpg", "png", "webp", "gif", "JPG", "PNG", "WEBP", "GIF":
                fullSizeImageUrl = imageName + "." + imageExtension
            default:
                fullSizeImageUrl = movie.imageURL.absoluteString
            }

            guard let imageURL = URL(string: "\(fullSizeImageUrl)") else {
                return
            }
            do {
                imageData = try Data(contentsOf: imageURL)
            } catch {
                self.delegate.didFailToLoadImage(with: error)
            }
            let rating = Float(movie.rating) ?? 0
            var floorRatingInt = Int.random(in: Int(floor(rating)) - 1...Int(floor(rating) + 1))
            if floorRatingInt < 0 {
                floorRatingInt = 0
            }
            if floorRatingInt > 10 {
                floorRatingInt = 10
            }
            let floorRating = Float(floorRatingInt)
            let randomBool = Bool.random()
            var compareSign: String
            var correctAnswer: Bool
            if randomBool {
                correctAnswer = floorRating >= rating
                compareSign = "больше"
            } else {
                correctAnswer = floorRating <= rating
                compareSign = "меньше"
            }
            let text = "Рейтинг этого фильма \(compareSign) \(String(format: "%.0f", floorRating))?"
            let title = movie.title
            let question = QuizeQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer,
                title: title
            )
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate.didReceiveNextQuestion(question: question)
            }
        }
    }

    func loadData() {
        moviesLoader.loadMovies(handler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.delegate.didFailToLoadData(with: error)
            case .success(let mostPopularMovies):
                if mostPopularMovies.errorMessage.isEmpty {
                    self.movies = mostPopularMovies.items.filter { $0.rating != "" }
                    self.delegate.didLoadDataFromServer()
                } else {
                    self.delegate.didReceiveErrorMessageInJSON(errorMessage: mostPopularMovies.errorMessage)
                }
            }
        })
    }

    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
}
