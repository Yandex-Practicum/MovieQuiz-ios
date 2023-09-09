import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Outlets & Actions
    @IBOutlet private weak var moviePosterImageView: UIImageView!
    @IBOutlet private weak var textOfQuestionLabel: UILabel!
    @IBOutlet private weak var indexOfQuestionLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBAction private func noButtonTapped(_ sender: UIButton) {
        let userAnswer = false
        showAnswerResult(isCorrect: userAnswer)
    }
    @IBAction private func yesButtonTapped(_ sender: UIButton) {
        let userAnswer = true
        showAnswerResult(isCorrect: userAnswer)
    }
    // MARK: - Structures
    /// вью модель состояния "Вопрос показан"
    private struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    /// вью модель состояния "Результат квиза"
    private struct QuizResultViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    /// модель вопроса квиза
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    // MARK: - Arrays, Variables, Constants
    /// массив моковых вопросов
    private var questions: [QuizQuestion] = [
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
    /// переменная с индексом текущего вопроса
    private var currentQuizQuestionIndex = 0
    /// переменная счетчика правильных ответов
    private var userCorrectAnswers = 0
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /// метод для перемешивания элементов массива - немного рандома для интереса
        questions.shuffle()
        let questionStep = questions[currentQuizQuestionIndex]
        let viewModel = convert(model: questionStep)
        showStep(quiz: viewModel)
    }
    // MARK: - Helper methods
    /// метод конвертации модели вопроса квиза во вью модель состояния "Вопрос показан"
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuizQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    /// метод для состояния "Вопрос показан"
    private func showStep(quiz step: QuizStepViewModel) {
        moviePosterImageView.image = step.image
        textOfQuestionLabel.text = step.question
        indexOfQuestionLabel.text = step.questionNumber
    }
    /// метод для изменения цвета рамки
    private func showAnswerResult(isCorrect: Bool) {
        moviePosterImageView.layer.masksToBounds = true
        moviePosterImageView.layer.borderWidth = 8
        moviePosterImageView.layer.cornerRadius = 20
        /// блокируем кнопки до загрузки следующего вопроса
        noButton.isEnabled = false
        yesButton.isEnabled = false
        if isCorrect == questions[currentQuizQuestionIndex].correctAnswer {
            moviePosterImageView.layer.borderColor = UIColor.ypGreen.cgColor
            userCorrectAnswers += 1
        } else {
            moviePosterImageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            /// "убираем" рамку после предыдущего ответа
            self.moviePosterImageView.layer.borderWidth = 0
            self.moviePosterImageView.layer.borderColor = UIColor.clear.cgColor
            /// разблокируем кнопки после появления нового вопроса
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
    }
    /// метод перехода в один из сценариев конечного автомата
    private func showNextQuestionOrResults() {
        if currentQuizQuestionIndex == questions.count - 1 {
            showResult(quiz: QuizResultViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(userCorrectAnswers)/\(questions.count)",
                buttonText: "Сыграть еще раз"))
        } else {
            currentQuizQuestionIndex += 1
            let questionStep = questions[currentQuizQuestionIndex]
            let viewModel = convert(model: questionStep)
            showStep(quiz: viewModel)
        }
    }
    /// метод для состояния "Результат квиза"
    private func showResult(quiz result: QuizResultViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        let alertAction = UIAlertAction(
            title: result.buttonText,
            style: .default) { _ in
                self.currentQuizQuestionIndex = 0
                self.userCorrectAnswers = 0
                /// снова перемешиваем элементы массива
                self.questions.shuffle()
                let startQuestion = self.questions[self.currentQuizQuestionIndex]
                let startView = self.convert(model: startQuestion)
                self.showStep(quiz: startView)
            }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}
// MARK: - Mocks
/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
