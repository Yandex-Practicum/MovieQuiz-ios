import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
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
        QuizQuestion(image: "The Godfather",
                     text: "Рейтинг этого фильма больше, чем 9?",
                     correctAnswer: true),
        QuizQuestion(image: "The Dark Knight",
                     text: "Рейтинг этого фильма больше, чем 8?",
                     correctAnswer: true),
        QuizQuestion(image: "Kill Bill",
                     text: "Рейтинг этого фильма меньше, чем 9?",
                     correctAnswer: true),
        QuizQuestion(image: "The Avengers",
                     text: "Рейтинг этого фильма меньше, чем 8?",
                     correctAnswer: false),
        QuizQuestion(image: "Deadpool",
                     text: "Рейтинг этого фильма больше, чем 7?",
                     correctAnswer: true),
        QuizQuestion(image: "The Green Knight",
                     text: "Рейтинг этого фильма меньше, чем 7?",
                     correctAnswer: true),
        QuizQuestion(image: "Old",
                     text: "Рейтинг этого фильма больше, чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                     text: "Рейтинг этого фильма меньше, чем 5?",
                     correctAnswer: true),
        QuizQuestion(image: "Tesla",
                     text: "Рейтинг этого фильма больше, чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Vivarium",
                     text: "Рейтинг этого фильма больше, чем 5?",
                     correctAnswer: true)
    ]
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        yesButton.layer.masksToBounds = true
        yesButton.layer.borderWidth = 4
        yesButton.layer.borderColor = UIColor.ypBackground.cgColor
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        noButton.layer.masksToBounds = true
        noButton.layer.borderWidth = 4
        noButton.layer.borderColor = UIColor.ypBackground.cgColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = convert(model: questions[currentQuestionIndex])
        show(quiz: viewModel)
    }
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    private func showAnswerResult(isCorrect: Bool) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        noButton.layer.borderWidth = 0
        yesButton.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        if isCorrect {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    private func showNextQuestionOrResults() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
        noButton.layer.borderWidth = 0
        yesButton.layer.borderWidth = 0
        imageView.layer.borderWidth = 0
        if currentQuestionIndex == questions.count - 1 {
            show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!", text: "Ваш результат: \(correctAnswers)/10", buttonText: "Сыграть ещё раз"))
        } else {
            currentQuestionIndex += 1
        }
        let nextQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: nextQuestion)
        show(quiz: viewModel)
    }
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: "Этот раунд окончен!",
                                      message: "Ваш результат: \(correctAnswers)/10",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
