import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?
    private var askedQuestions: [Int] = []
    
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    private let question: String = "Рейтинг этого фильма больше чем 6?"
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

    func requestNextQuestion() {
        var newIndex: Int
        repeat {
            guard let indexQuestion = (0..<questions.count).randomElement() else {
                delegate?.didReceiveNextQuestion(question: nil)
                return
            }
            newIndex = indexQuestion
        } while askedQuestions.contains(newIndex)
        
        askedQuestions.append(newIndex)
        let question = questions[safe: newIndex]
        delegate?.didReceiveNextQuestion(question: question)
    }

    }
