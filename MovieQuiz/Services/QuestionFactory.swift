import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    private enum Compare: String, CaseIterable {
        case more = "больше"
        case less = "меньше"
    }
    
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            
            DispatchQueue.main.async {
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
        DispatchQueue.global().async { [weak self] in
            
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data() // по умолчанию у нас просто будут пустые данные
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
                
                let rating = Float(movie.rating) ?? 0 // превращаем строку в число
                let textNumber = Float.random(in: 8.0...9.2)
                let roundedTextNumber = round(textNumber * 10) / 10.0
                let randomCompareText = Compare.allCases.randomElement()!
                
                let text = "Рейтинг этого фильма \(randomCompareText.rawValue), чем \(roundedTextNumber)?"
                
                var correctAnswer: Bool {
                    
                    switch randomCompareText {
                        case .more:
                            return rating > roundedTextNumber
                        case .less:
                            return rating < roundedTextNumber
                    }
                }
                
                let question = QuizQuestion(image: imageData,
                                            text: text,
                                            correctAnswer: correctAnswer)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didReceiveNextQuestion(question: question)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.delegate?.didFailToLoadData(with: error)
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
