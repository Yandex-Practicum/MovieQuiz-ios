// swiftlint:disable all

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    private enum QuesionsError: Error {
        case noElements, noImages
    }
    
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    
    init(delegate: QuestionFactoryDelegate, moviesLoader: MoviesLoading) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
    
    // Получаем следующий рандомный вопрос из массива
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else {
                if let safeDelegate = self.delegate {
                    safeDelegate.didFailToLoadData(with: QuesionsError.noElements)
                }
                return
            }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.imageURL)
            } catch {
                if let safeDelegate = self.delegate {
                    safeDelegate.didFailToLoadData(with: QuesionsError.noImages)
                }
                print("Failed to load image")
                return
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
            
            let question = QuizQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer
            )
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let safeDelegate = self.delegate {
                    safeDelegate.didReceiveNextQuestion(question: question)
                }
            }
        }
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let mostPopularMovies):
                self.movies = mostPopularMovies.items // сохраняем фильм в нашу новую переменную
                if let safeDelegate = self.delegate {
                    safeDelegate.didLoadDataFromServer() // сообщаем, что данные загрузились
                }
            case .failure(let error):
                if let safeDelegate = self.delegate {
                    safeDelegate.didFailToLoadData(with: error) // сообщаем об ошибке нашему MovieQuizViewController
                }
            }
            
        }
    }
}



/*
 private let questions: [QuizQuestion] = [
 QuizQuestion(
 image: "The Godfather",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: true),
 QuizQuestion(
 image: "The Dark Knight",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: true),
 QuizQuestion(
 image: "Kill Bill",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: true),
 QuizQuestion(
 image: "The Avengers",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: true),
 QuizQuestion(
 image: "Deadpool",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: true),
 QuizQuestion(
 image: "The Green Knight",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: false),
 QuizQuestion(
 image: "Old",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: false),
 QuizQuestion(
 image: "The Ice Age Adventures of Buck Wild",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: false),
 QuizQuestion(
 image: "Tesla",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: false),
 QuizQuestion(
 image: "Vivarium",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: false)
 ]
 */
