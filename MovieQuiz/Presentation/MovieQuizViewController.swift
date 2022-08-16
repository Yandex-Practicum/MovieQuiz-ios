import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var noAnswerButton: UIButton!
    @IBOutlet weak var yesAnswerButton: UIButton!
    
    var counterAnswers: Int = 0 // счетчик на каком вопросе мы находимся
    var currentQuestionIndex: Int = 0 // индекс нашего вопроса
    var counterCorrectAnswers: Int = 0
    var numberOfQuizGames: Int = 0
    var recordCorrectAnswers: Int = 0
    var recordDate = Date()
    var averageAccuracy = 0.0
    var numberOfQuizQuestion: Int = 10
    var allCorrectAnswers: Int = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer == false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer == true)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        UIView.animate(withDuration: 0.1) {
            self.textLabel.text = step.question
            self.counterLabel.text = step.questionNumber
            self.imageView.image = step.image
        }
    }

    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText,
                                   style: .default,
                                   handler: {
                                    _ in self.restart()
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? .remove,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(numberOfQuizQuestion)")
    }
    
    private func restart() {
        currentQuestionIndex = 0
        viewModel()
    }
    
    private func viewModel() {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
        let viewModel = convert(model: questions[currentQuestionIndex])
        show(quiz: viewModel)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            numberOfQuizGames += 1
            allCorrectAnswers += counterCorrectAnswers
            let resultQuiz = getResultQuiz()
            show(quiz: resultQuiz)
        } else {
            currentQuestionIndex += 1
            viewModel()
        }
    }
    
    private func getResultQuiz() -> QuizResultsViewModel {
        var title = "Игра окончена!"
        var recordDateString = ""
        if counterCorrectAnswers >= recordCorrectAnswers {
            title = "новый рекорд"
            recordCorrectAnswers = counterCorrectAnswers
            recordDateString = Date().dateTimeString
        }
        
        if counterCorrectAnswers == numberOfQuizGames {
            title = "Поздравляем! Это лучший результат"
        }
        averageAccuracy = Double(allCorrectAnswers * 100) / Double(numberOfQuizQuestion * numberOfQuizGames)
        let resultQuiz = QuizResultsViewModel(title: title,
                                             text: """
                                             Ваш результат: \(counterCorrectAnswers)/\(numberOfQuizQuestion)
                                             Количество сыгранных квизов: \(numberOfQuizGames)
                                             Рекорд: \(recordCorrectAnswers)/\(numberOfQuizQuestion) \(recordDateString)
                                             Средняя точность: \(String(format: "%.02f", averageAccuracy))%
                                             """,
                                             buttonText: "Новая игра")
        return resultQuiz
    }
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }

    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }

    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }

    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true), // Настоящий рейтинг: 9,2
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true), // Настоящий рейтинг: 9
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true), // Настоящий рейтинг: 8,1
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true), // Настоящий рейтинг: 8
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true), // Настоящий рейтинг: 8
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),  // Настоящий рейтинг: 6,6
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),  // Настоящий рейтинг: 5,8
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),  // Настоящий рейтинг: 4,3
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),  // Настоящий рейтинг: 5,1
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)  // Настоящий рейтинг 5,8
    ]
}
