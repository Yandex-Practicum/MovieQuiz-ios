import UIKit

final class MovieQuizViewController: UIViewController {
    private var currentQuestionIndex: Int = 0
    private var score = 0
    private var totalScore = 0
    private var quizSum: Int = 0
    private var averageAccuracy: Float = 0
    private var bestQuizResult = (score: 0, date: "")
    private var currentDate: String { Date().dateTimeString }

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        let quiz = convert(model: questions[currentQuestionIndex])
        showQuestion(quiz: quiz)
    }
    // MARK: - Обработка ответа от пользователя
    @IBAction private func yesButtonClicked(_ sender: UIButton) {toggleAnswerButtons()
        let result = questions[currentQuestionIndex].correctAnswer == true
         if result {
             score += 1
         }
        showAnswerResult(isCorrect: result)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
             self.showNextQuestionOrResults()
             self.toggleAnswerButtons()
         }    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {toggleAnswerButtons()
        let result = questions[currentQuestionIndex].correctAnswer == false
        if result {
            score += 1
        }
        showAnswerResult(isCorrect: result)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showNextQuestionOrResults()
            self.toggleAnswerButtons()
        }
    }
    // MARK: - Mock-данные
    private struct QuizQuestion {
        let imageName: UIImage?
        let rating: Float
        let questionText: String
        let correctAnswer: Bool
    }

    private let questions: [QuizQuestion] = [
QuizQuestion(
    imageName: UIImage(named: "The Godfather"),
    rating: 9.2,
    questionText: "Рейтинг этого фильма больше чем 6?",
    correctAnswer: true),
QuizQuestion(
    imageName: UIImage(named: "The Dark Knight"),
    rating: 9,
    questionText: "Рейтинг этого фильма больше чем 6?",
    correctAnswer: true),
QuizQuestion(
    imageName: UIImage(named: "Kill Bill"),
    rating: 9.2,
    questionText: "Рейтинг этого фильма больше чем 6?",
    correctAnswer: true),
QuizQuestion(
    imageName: UIImage(named: "The Avengers"),
    rating: 8,
    questionText: "Рейтинг этого фильма больше чем 6?",
    correctAnswer: true),
QuizQuestion(
    imageName: UIImage(named: "Deadpool"),
    rating: 8,
    questionText: "Рейтинг этого фильма больше чем 6?",
    correctAnswer: true),
QuizQuestion(
    imageName: UIImage(named: "The Green Knight"),
    rating: 6.6,
    questionText: "Рейтинг этого фильма больше чем 6?",
    correctAnswer: true),
QuizQuestion(
    imageName: UIImage(named: "Old"),
    rating: 5.8,
    questionText: "Рейтинг этого фильма больше чем 6?",
    correctAnswer: false),
QuizQuestion(
    imageName: UIImage(named: "The Ice Age Adventures of Buck Wild"),
    rating: 4.3,
    questionText: "Рейтинг этого фильма больше чем 6?",
    correctAnswer: false),
QuizQuestion(
    imageName: UIImage(named: "Tesla"),
    rating: 5.1,
    questionText: "Рейтинг этого фильма больше чем 6?",
    correctAnswer: false),
QuizQuestion(
    imageName: UIImage(named: "Vivarium"),
    rating: 5.8,
    questionText: "Рейтинг этого фильма больше чем 6?",
    correctAnswer: false)
    ]
    // MARK: - модели данных для вьюшек
    private struct QuizStepViewModel {
        let image: UIImage?
        let questionText: String
        let questionNumber: String
    }

    private struct QuizResultsViewModel {
        let title: String
        let textResult: String
        let buttonText: String
    }

    private struct AnswerResultsViewModel {
        let answerResult: Bool
    }
    // MARK: - функции, которые будут показывать вью модели на экране
    private func showQuestion(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.questionText
        counterLabel.text = step.questionNumber
    }
    // MARK: - функция конвертирования данных для первой вью модели
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let step = QuizStepViewModel(
            image: model.imageName,
            questionText: model.questionText,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
        return step
    }
    // MARK: - Функция для подсветки корректности результата ответа
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = UIColor(named: isCorrect ? "YP Green" : "YP Red")?.cgColor
    }

    private func toggleAnswerButtons() {
        noButton.isEnabled.toggle()
        yesButton.isEnabled.toggle()
    }
    // MARK: - Показываем следующий шаг
    private func showNextQuestionOrResults() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            let quiz = convert(model: questions[currentQuestionIndex])
            imageView.layer.borderWidth = 0
            showQuestion(quiz: quiz)
        } else {
            quizSum += 1
            totalScore += score
            averageAccuracy = Float(totalScore * 1000 / (questions.count * quizSum)) / 10
            let title = score == questions.count ? "Поздравляем!" : "Этот раунд окончен!"
            showResults(quiz: QuizResultsViewModel(
                title: title,
                textResult: """
                Ваш результат: \(score)/\(questions.count)
                Количество сыгранных квизов: \(quizSum)
                Средняя точность: \(averageAccuracy)%
                """,
                buttonText: "Сыграть еще раз"))
        }
    }

    // MARK: - Показываем результат
    private func showResults(quiz step: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: step.title,
            message: step.textResult,
            preferredStyle: .alert // preferredStyle может быть .alert или .actionSheet
        )
        let action = UIAlertAction(title: step.buttonText, style: .default) { _ in
            self.startNewRound()
        }
        alert.addAction(action) // добавляем в алерт кнопки
        self.present(alert, animated: true, completion: nil) // показываем всплывающее окно
    }
    private func startNewRound() {
        imageView.layer.borderColor = nil
        currentQuestionIndex = 0
        score = 0
        let quiz = convert(model: questions[currentQuestionIndex])
        showQuestion(quiz: quiz)
    }
}
