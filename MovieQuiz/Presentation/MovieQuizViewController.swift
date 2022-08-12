import UIKit

final class MovieQuizViewController: UIViewController {
    private var currentQuestionIndex: Int = 0

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    // MARK: - первый вывод данных на экран
    override func viewDidLoad() {
        super.viewDidLoad()
        let quiz = convert(model: questions[currentQuestionIndex])
        showQuestion(quiz: quiz)
    }
    // MARK: - Обработка ответа от пользователя
    @IBAction private func yesButtonClicked(_ sender: UIButton) {

    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {

    }
    // MARK: - Mock-данные
    private struct QuizQuestion {
        let imageName: UIImage?
        let rating: Float
        let questionText: String
        let answer: Bool
    }

    private let questions: [QuizQuestion] = [
        QuizQuestion(imageName: UIImage(named: "The Godfather"),rating: 9.2,questionText: "Рейтинг этого фильма больше чем 6?",answer: true),
        QuizQuestion(imageName: UIImage(named: "The Dark Knight"),rating: 9,questionText: "Рейтинг этого фильма больше чем 6?",answer: true),
        QuizQuestion(imageName: UIImage(named: "Kill Bill"),rating: 9.2,questionText: "Рейтинг этого фильма больше чем 6?",answer: true),
        QuizQuestion(imageName: UIImage(named: "The Avengers"),rating: 8,questionText: "Рейтинг этого фильма больше чем 6?",answer: true),
        QuizQuestion(imageName: UIImage(named: "Deadpool"),rating: 8,questionText: "Рейтинг этого фильма больше чем 6?",answer: true),
        QuizQuestion(imageName: UIImage(named: "The Green Knight"),rating: 6.6,questionText: "Рейтинг этого фильма больше чем 6?",answer: true),
        QuizQuestion(imageName: UIImage(named: "Old"),rating: 5.8,questionText: "Рейтинг этого фильма больше чем 6?",answer: false),
        QuizQuestion(imageName: UIImage(named: "The Ice Age Adventures of Buck Wild"),rating: 4.3,questionText: "Рейтинг этого фильма больше чем 6?",answer: false),
        QuizQuestion(imageName: UIImage(named: "Tesla"),rating: 5.1,questionText: "Рейтинг этого фильма больше чем 6?",answer: false),
        QuizQuestion(imageName: UIImage(named: "Vivarium"),rating: 5.8,questionText: "Рейтинг этого фильма больше чем 6?",answer: false)
    ]
    // MARK: - модели данных для вьюшек
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

    private struct AnswerResultsViewModel {
        let answerResult: Bool
    }
    // MARK: - функции, которые будут показывать вью модели на экране
    private func showQuestion(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.questionText
        counterLabel.text = step.questionNumber
    }

    private func showResults(quiz step: QuizResultsViewModel) {

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
    // MARK: - функция для подсветки корректности результата ответа
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
}
