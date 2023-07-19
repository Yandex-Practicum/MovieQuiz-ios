import Foundation
import UIKit

class QuestionFactory: QuestionFactoryProtocol {
    // Зависимость от протокола `MoviesLoading`, который отвечает за загрузку фильмов
    private let moviesLoader: MoviesLoading
    // Ссылка на делегата, который будет получать уведомления о событиях от QuestionFactory
    private var delegate: QuestionFactoryDelegate?
    // Инициализация QuestionFactory с внедрением зависимостей
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    // Массив фильмов, который будет использоваться для создания вопросов
    private var movies: [MostPopularMovie] = []
    // Набор индексов уже использованных фильмов
    var usedIndices: Set<Int> = []
    // Сброс использованных индексов
    func resetUsedIndices() {
        usedIndices = []
    }
    
    // Загрузка данных о фильмах
    func loadData() {
        // Использование moviesLoader для загрузки фильмов
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    // Сохранение загруженных фильмов и уведомление делегата о загрузке данных
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    // Уведомление делегата об ошибке при загрузке данных
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    // Запрос следующего вопроса
    func requestNextQuestion() {
        // Асинхронная обработка запроса на глобальной очереди
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            // Генерация случайного индекса для выбора случайного фильма из массива
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            var imageData = Data()
            do {
                // Загрузка изображения фильма
                imageData = try Data(contentsOf: movie.resizedImageURL)
                let rating = Float(movie.rating) ?? 0
                let text = "Рейтинг этого фильма больше чем 7?"
                let correctAnswer = rating > 7
                // Создание объекта QuizQuestion на основе загруженных данных
                let question = QuizQuestion(image: imageData,
                                            text: text,
                                            correctAnswer: correctAnswer)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    // Уведомление делегата о получении следующего вопроса
                    self.delegate?.didReceiveNextQuestion(question: question)
                }
            } catch {
                print("Failed to load image")
            }
        }
    }
}

//    private let questions: [QuizQuestion] = [
//        QuizQuestion(
//            image: "The Godfather",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "The Dark Knight",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "Kill Bill",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "The Avengers",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "Deadpool",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "The Green Knight",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "Old",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "The Ice Age Adventures of Buck Wild",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "Tesla",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "Vivarium",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false)
//    ]
