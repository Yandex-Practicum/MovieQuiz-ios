import UIKit

final class MovieQuizViewController: UIViewController {
    private struct QuizQuestion {
        let image: UIImage?
        let rating: Float
        let question: String
        let answer: Bool
    }
    private struct QuizStepViewModel {
        let image: UIImage?
        let questionText: String
        let questionNumber: String
    }
    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }

    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: UIImage(named: "The Godfather"),
            rating: 9.2,
            question: "Рейтинг этого фильма больше чем 6?",
            answer: true),
        QuizQuestion(
            image: UIImage(named: "The Dark Knight"),
            rating: 9,
            question: "Рейтинг этого фильма больше чем 6?",
            answer: true),
        QuizQuestion(
            image: UIImage(named: "Kill Bill"),
            rating: 9.2,
            question: "Рейтинг этого фильма больше чем 6?",
            answer: true),
        QuizQuestion(
            image: UIImage(named: "The Avengers"),
            rating: 8,
            question: "Рейтинг этого фильма больше чем 6?",
            answer: true),
        QuizQuestion(
            image: UIImage(named: "Deadpool"),
            rating: 8,
            question: "Рейтинг этого фильма больше чем 6?",
            answer: true),
        QuizQuestion(
            image: UIImage(named: "The Green Knight"),
            rating: 6.6,
            question: "Рейтинг этого фильма больше чем 6?",
            answer: true),
        QuizQuestion(
            image: UIImage(named: "Old"),
            rating: 5.8,
            question: "Рейтинг этого фильма больше чем 6?",
            answer: false),
        QuizQuestion(
            image: UIImage(named: "The Ice Age Adventures of Buck Wild"),
            rating: 4.3,
            question: "Рейтинг этого фильма больше чем 6?",
            answer: false),
        QuizQuestion(
            image: UIImage(named: "Tesla"),
            rating: 5.1,
            question: "Рейтинг этого фильма больше чем 6?",
            answer: false),
        QuizQuestion(
            image: UIImage(named: "Vivarium"),
            rating: 5.8,
            question: "Рейтинг этого фильма больше чем 6?",
            answer: false)
    ]

    private var currentQuestionIndex = 0
    private var score = 0
    private var totalScore = 0
    private var highestScore = 0
    private var highestScoreDate = ""
    private var quizesPlayed = 0
    private var averageAccuracy: Float = 0
    private let dateFormatter = DateFormatter()
    private let dateFormat = "dd.MM.yy HH:mm"

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        dateFormatter.dateFormat = dateFormat
        let quiz = convert(model: questions[currentQuestionIndex])
        showQuestion(quiz: quiz)
    }

    private func showQuestion(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.questionText
        counterLabel.text = step.questionNumber
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        handleButtonClick(answerWasCorrect: questions[currentQuestionIndex].answer == true)
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        handleButtonClick(answerWasCorrect: questions[currentQuestionIndex].answer == false)
    }

    private func handleButtonClick(answerWasCorrect: Bool) {
        toggleAnswerButtons()
        if answerWasCorrect {
            score += 1
        }
        setImageBorder(answerWasCorrect: answerWasCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            [weak self] in
            self?.showNextQuestionOrResults()
            self?.toggleAnswerButtons()
        }
    }

    private func toggleAnswerButtons() {
        noButton.isEnabled.toggle()
        yesButton.isEnabled.toggle()
    }

    private func setImageBorder(answerWasCorrect: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor(named: answerWasCorrect ? "YP Green" : "YP Red")?.cgColor
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            let quiz = convert(model: questions[currentQuestionIndex])
            imageView.layer.borderWidth = 0
            showQuestion(quiz: quiz)
        } else {
            quizesPlayed += 1
            totalScore += score
            if score > highestScore {
                highestScore = score
                highestScoreDate = dateFormatter.string(from: Date())
            }
            averageAccuracy = Float(totalScore * 1000 / (questions.count * quizesPlayed)) / 10
            let title = score == questions.count ? "Поздравляем!" : "Этот раунд окончен!"
            showResults(quiz: QuizResultsViewModel(
                title: title,
                text: """
                Ваш результат: \(score)/\(questions.count)
                Количество сыгранных квизов: \(quizesPlayed)
                Рекорд: \(highestScore)/\(questions.count) (\(highestScoreDate))
                Средняя точность: \(averageAccuracy)%
                """,
                buttonText: "Сыграть еще раз"))
        }
    }

    private func showResults(quiz step: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: step.title,
            message: step.text,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: step.buttonText, style: .default) { [weak self] _ in
            self?.startNewRound()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    private func startNewRound() {
        imageView.layer.borderWidth = 0
        currentQuestionIndex = 0
        score = 0
        let quiz = convert(model: questions[currentQuestionIndex])
        showQuestion(quiz: quiz)
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let step = QuizStepViewModel(
            image: model.image,
            questionText: model.question,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
        return step
    }
}
