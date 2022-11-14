import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    private var currentQuestionIndex: Int = 0

   
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // для состояния "Вопрос задан"
        struct QuizStepViewModel {
          let image: UIImage
          let question: String
          let questionNumber: String
        }
        func show(quiz step: QuizStepViewModel) {
          // здесь мы заполняем нашу картинку, текст и счётчик данными
        }
        // для состояния "Результат квиза"
        struct QuizResultsViewModel {
          let title: String
          let text: String
          let buttonText: String
        }
        func show(quiz result: QuizResultsViewModel) {
          // здесь мы показываем результат прохождения квиза
        }
        struct QuizQuestion {
            let image: String
            let text: String
            let correctAnswer: Bool
        
            private func convert(model: QuizQuestion) -> QuizStepViewModel {
                return QuizStepViewModel(
                    image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
                    question: model.text, // берём текст вопроса
                    questionNumber: "\(currentQuestionIndex + 1)/\(question.count)") // высчитываем номер вопроса
            }
            
            private let question: [QuizQuestion] = [
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
        }
        
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
    }
    
}
