//
//  Question Factory.swift
//  MovieQuiz
//
//  Created by Дмитрий Калько on 12.09.2023.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    
    // MARK: -initialisator
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    // MARK: -properties
    private var movies: [MostPopularMovie] = []
    
    
    
    // MARK: -functions
    //загружаем данные о фильмах
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case.success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items //сохраняем фильм в новую переменную
                    self.delegate?.didLoadDataFromServer() //сообщаем, что данные загрузились
                case.failure(let error):
                    self.delegate?.didFailToLoadData(with: error) // сообщаем об ошибке moviesquizcontroller
                }
            }
        }
    }
    
    //запрашиваем следующий вопрос
    func requestNextQuestion() {
        
        //зпускам код в другом потоке
        DispatchQueue.global().async { [weak self] in
            
            //выбирам произвольный элемент из массива
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            
            //создаем данные из url
            var imageData = Data() // по умолчанию просто пустые данные
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            
            //создаем вопрос определяем его корректность и создаем модель вопроса
            let rating = Float(movie.rating) ?? 0
            
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
            
            let question = QuizQuestion (image: imageData,
                                         text: text,
                                         correctAnswer: correctAnswer)
            
            
            //возвращаемся в главный поток
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
                
            }
            
        }
        
        
        
        
        
        
        
        /*
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
         */
    }
}
/*
 //массив мок вопросов
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
