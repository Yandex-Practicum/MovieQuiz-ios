//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Toto Tsipun on 07.11.2022.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoadingProtocol //связываем загрузчик с QuestionFactory
    private var movies: [MostPopularMovie] = []
    weak var delegate: QuestionFactoryDelegate? //фабрика будет общаться с этим свойством
    //Мало создать фабрику и делегата — нужно как-то сообщить фабрике о делегате.
    
    init(delegate: QuestionFactoryDelegate?, moviesLoader: MoviesLoadingProtocol) { // тот, кто будет инициализировать фабрику должен будет указать ее делегата
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
    
    //    private let questions: [QuizQuestion] = [
    //        QuizQuestion(image: "The Godfather",
    //                     text: "Рейтинг этого фильма больше 7?",
    //                     correctAnswer: true),
    //        QuizQuestion(image: "The Dark Knight",
    //                     text: "Рейтинг этого фильма больше 7?",
    //                     correctAnswer: true),
    //        QuizQuestion(image: "Kill Bill",
    //                     text: "Рейтинг этого фильма больше 7?",
    //                     correctAnswer: true),
    //        QuizQuestion(image: "The Avengers",
    //                     text: "Рейтинг этого фильма больше 7?",
    //                     correctAnswer: true),
    //        QuizQuestion(image: "Deadpool",
    //                     text: "Рейтинг этого фильма больше 7?",
    //                     correctAnswer: true),
    //        QuizQuestion(image: "The Green Knight",
    //                     text: "Рейтинг этого фильма больше 7?",
    //                     correctAnswer: true),
    //        QuizQuestion(image: "Old",
    //                     text: "Рейтинг этого фильма больше 7?",
    //                     correctAnswer: false),
    //        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
    //                     text: "Рейтинг этого фильма больше 7?",
    //                     correctAnswer: false),
    //        QuizQuestion(image: "Tesla",
    //                     text: "Рейтинг этого фильма больше 7?",
    //                     correctAnswer: false),
    //        QuizQuestion(image: "Vivarium",
    //                     text: "Рейтинг этого фильма больше 7?",
    //                     correctAnswer: false)
    //    ]
    
    func loadData() {
        // Обрабатываем ответ от загрузчика фильмов
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async { // возвращаемся в главный поток
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items // сохраняем фильм в нашу новую переменную
                    self.delegate?.didLoadDataFromServer() // сообщаем, что данные загрузились
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error) // сообщаем об ошибке нашему MovieQuizViewController
                }
            }
        }
    }
    
    func requestNextQuestion() {
        
        DispatchQueue.global().async { [weak self] in // запускаем код в другом потоке
            // Выбираем произвольный элемент из массива, чтобы показать его.
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data() // по умолчанию у нас будут просто пустые данные
            // Создаем данные из URL, если загрузка идет не по плану, то обрабатываем ошибку
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            // Создаём вопрос, определяем его корректность и создаём модель вопроса
            let rating = Float(movie.rating) ?? 0
            
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            // Загрузка и обработка данных завершена - возвращаемся в главный поток
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question) // показываем новый вопрос через делегата
            }
        }
    }
}
