//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Artem Adiev on 06.12.2022.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate) { // Обновленный init для передачи загрузчика в момент создания QuestionFactory
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
    
    private var movies: [MostPopularMovie] = [] // Складываем сюда загруженные с сервера фильмы
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async { // Когда обрабатываем ответ от загрузчика - возвращаемся в главный поток через .main.async
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items // Сохраняем фильм в новую переменную
                    self.delegate?.didLoadDataFromServer() // Сообщаем, что данные загрузились с сервера
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error) // Сообщаем об ошибке нашему MovieQuizController
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in // Запускаем код в другом потоке, чтобы не блокировать основной поток своими задачами
            // Выбираем произвольный элемент из массива, чтобы показать его
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            // Используем "трюк" с созданием данных из URL. Т.к. загрузка может быть неудачной - обрабатываем ошибку
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.imageURL)
            } catch {
                print("Failed to load image")
            }
            
            // Создаем вопрос, определяем его корректность и создаем модель вопроса
            let rating = Float(movie.rating) ?? 0
            
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            // Когда загрузка и обработка данных завершена - возвращаемся в главный поток
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didRecieveNextQuestion(question: question)
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
            correctAnswer: true),
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
    
    /* Старая функция для работы с моковыми данными
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didRecieveNextQuestion(question: nil)
            return
        }
        let question = questions[safe: index]
        delegate?.didRecieveNextQuestion(question: question)
    }
    */
}
