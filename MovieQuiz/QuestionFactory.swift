import Foundation
import UIKit

class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoadingProtocol
    
    init(delegate: QuestionFactoryDelegate?, moviesLoader: MoviesLoadingProtocol) {
        print("QuestionFactory-MoviesLoader init")
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
    
    private var movies: [MostPopularMovie?] = []
    private var quizQuestions = [QuizQuestion]()
//        QuizQuestion(image: "The Godfather",
//                  text: "Рейтинг этого фильма больше чем 7?",
//                  correctAnswer: true),
//        QuizQuestion(image: "The Dark Knight",
//                  text: "Рейтинг этого фильма больше чем 7?",
//                  correctAnswer: false),
//        QuizQuestion(image: "Kill Bill",
//                  text: "Рейтинг этого фильма больше чем 7?",
//                  correctAnswer: true),
//        QuizQuestion(image: "The Avengers",
//                  text: "Рейтинг этого фильма больше чем 7?",
//                  correctAnswer: true),
//        QuizQuestion(image: "Deadpool",
//                  text: "Рейтинг этого фильма больше чем 7?",
//                  correctAnswer: false),
//        QuizQuestion(image: "The Green Knight",
//                  text: "Рейтинг этого фильма больше чем 6?",
//                  correctAnswer: true),
//        QuizQuestion(image: "Old",
//                  text: "Рейтинг этого фильма больше чем 6?",
//                  correctAnswer: false),
//        QuizQuestion(image: "Tesla",
//                  text: "Рейтинг этого фильма больше чем 6?",
//                  correctAnswer: false),
//        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
//                  text: "Рейтинг этого фильма больше чем 6?",
//                  correctAnswer: false),
//        QuizQuestion(image: "Vivarium",
//                  text: "Рейтинг этого фильма больше чем 6?",
//                  correctAnswer: false),
//    ]
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success(let movie):
                    
                    self.movies = movie.items
                    self.delegate?.didLoadDataFromServer()
                    
                case .failure(let error):
                    self.delegate?.didFailToLoadDataFromServer(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        
        DispatchQueue.global().async { [weak self] in
            print("requestNextQuestion")
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
             
            guard let question = self.movies[safe: index],
                  let question = question else {return}
            
            guard let imageUrl = question.imageURL else {
                print("imageUrl ❌")
                return
            }
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: imageUrl)
            } catch {
                    print("Fail to load image ❌")
            }

            let randomNumber = Double.random(in: 5.1...9.2)
            let correctAnswer = (question.rating > randomNumber)
            let text = "Рейтинг этого фильма больше чем \(randomNumber.myOwnRounded)?"
                
            let readyQuestion = QuizQuestion(image: imageData,
                                             text: text,
                                             correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.delegate?.didReceiveNextQuestion(question: readyQuestion)
            }
        }
    }
}
