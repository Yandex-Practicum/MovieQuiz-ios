//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Fedor on 14.11.2023.
//

import Foundation

//Моки данные для заполнения массива вопросов квиза
//private var theGodfather = QuizQuestion(image: "The Godfather", text: "Рейтин этого фильма больше чем 6?", correctAnswer: true)
//
//private var theDarkKnight = QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)
//
//private var killBill = QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)
//
//private var theAvengers = QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)
//
//private var deadpool = QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)
//
//private var theGreenKnight = QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)
//
//private var old = QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
//
//private var theIceAgeAdvanturesOfBuckWild = QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)
//
//private var tesla = QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)
//
//private var vivarium = QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)

class QuestionFactory: QuestionFactoryProtocol {
    
//    private let questions: [QuizQuestion] = [theGodfather, theDarkKnight, killBill, theAvengers, deadpool, theGreenKnight, old, theIceAgeAdvanturesOfBuckWild, tesla, vivarium]
    
    //Определяем делегата для фабрики вопросов
    var movieLoader: MoviesLoaderProtocol
    weak var delegate: QuestionFactoryDelegatePrototocol?
    private var movies: [MostPopularMovie] = []
    
    init(movieLoader: MoviesLoaderProtocol) {
        self.movieLoader = movieLoader
    }
    
    func loadData() {
        movieLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let data):
                    self.movies = data.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        
        //выбираем случайный элемент QuizeQuestion из массива вопросов по индексу элемента
        //        guard let index = (0..<questions.count).randomElement() else {
        //            delegate?.didFinishReceiveQuestion(question: nil)
        //            return }
        //
        //        let question = questions[safe: index]
        
        DispatchQueue.global().async { [weak self] in
            
            guard let self = self else { return }
            guard let index  = (0..<self.movies.count).randomElement() else {
                self.delegate?.didFinishReceiveQuestion(question: nil)
                return
            }
            
            var imageData = Data()
            
            guard let movie = self.movies[safe: index] else { return }
            do {
                imageData = try Data(contentsOf: movie.finalImageUrl)
                
            } catch{
                print("изображение не загружено")
            }
            
            guard let questionRating = (1...9).randomElement() else { return }
            let text = "Рейтинг этого фильма больше, чем \(questionRating)?"
            print(text)
            let rating: Double = Double(movie.rating) ?? 0
            let correctAnswer = rating > Double(questionRating)
            
            let question = QuizQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                //Передаем структуру QuizQuestion делегату
                self.delegate?.didFinishReceiveQuestion(question: question)
            }
        }
    }
}
