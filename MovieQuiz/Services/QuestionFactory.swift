//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Veniamin on 11.11.2022.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol { //устанавливаем протокол, в котором содержится метод requestNextQuestion
    
    private let moviesLoader: MoviesLoading //связываем загрузчик с QuestionFactory

    weak var delegate: QuestionFactoryDelegate?  //фабрика будет общаться с этим свойством
    //Мало создать фабрику и делегата — нужно как-то сообщить фабрике о делегате.
    
    init(delegate: QuestionFactoryDelegate?, moviesLoader: MoviesLoading) { // тот, кто будет инициализировать фабрику должен будет указать ее делегата
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    } 
    
    private var movies: [MostPopularMovie] = []
    
    func loadData() { // функция загрузки
        moviesLoader.loadMovies{result in // почему именно такой порядок ??? в начале loadMovies -> перевод в другой поток
            DispatchQueue.main.async(){[weak self] in
                guard let self = self else {return}
                switch result {
                case .success(let mostPopularMovies): // почему тут в success передается let??? и откуда у нас эта переменная
                    self.movies = mostPopularMovies.items // сохраняем фильм в нашу новую переменную
                    self.delegate.didLoadDataFromServer() // сообщаем, что данные загрузились
                case .failure(let error):
                    self.delegate.didFailToLoadData(with: error) // сообщаем об ошибке нашему MovieQuizViewController
                }
            }
        }
    }
    
    
    // MARK: исходные данные
//    private let questions: [QuizQuestion] = [
//                                     QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//                                     QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//                                     QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//                                     QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//                                     QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//                                     QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//                                     QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
//                                     QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
//                                     QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
//                                     QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
//                                     ]
    
    func requestNextQuestion() {                       // 1
//        guard let index = (0..<questions.count).randomElement() else {  // 2
//            delegate?.didReceiveNextQuestion(question: nil) //отправляем в делегат пустоту
//            return
//        }
//        let question = questions[safe: index]
//        delegate?.didReceiveNextQuestion(question: question) //отправляем в делегат вопрос
        
        
        DispatchQueue.global.async(){ [weak self] in // перевод в другой поток
            guard let self = self else {return}
            
            let index = (0..<self.movies.count).randomElement() ?? 0 //получается что на момент вызова этой функции все фильмы уже загружены в массив movies?
            
            guard let movie = self.movies[safe: index] else {return} // берем конкретный фильм
            
            var imageData = Data() // инициализируем как пустой Data
            
            do { // пытаемся получить картинку
                imageData = try Data(contentsOf: movie.imageURL)
            }else {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0 // преобразуем текстовый рейтинг из JSON в дробь
            
            let board = (1..<10).randomElement()! // задаем рандомную границу для вопроса
            
            let text = "Рейтинг этого фильма больше \(board)?"
            let correctAnswer = rating > board
            
            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
            
            
            DispatchQueue.main.async(){[weak self] in // возвращение в основной поток
                guard let self = self else {return}
                self.delegate?.didReceiveNextQuestion(question: question) // показываем новый вопрос
                
            }
        }
    } 
} 
