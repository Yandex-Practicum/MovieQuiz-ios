import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Outlets and Actions

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private var buttons: [UIButton]!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: checkAnswerCorrectness(for: true))
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: checkAnswerCorrectness(for: false))
    }

    // MARK: - Vars

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
            correctAnswer: false),
    ]

    private var currentQuestionIndex: Int = 0
    private var correctAnswersCount: Int = 0
    private var currentQuestionCorrectAnswer: Bool? {
        questions[safe: currentQuestionIndex]?.correctAnswer
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let firstQuestion = questions.first else { return }
        
        imageView.layer.masksToBounds = true

        show(quiz: convert(model: firstQuestion))
    }
    
    // MARK: - Methods
    
    private func toggleButtonsEnableProperty(to value: Bool) {
        buttons.forEach { $0.isEnabled = value }
    }

    private func checkAnswerCorrectness(for chosenAnswer: Bool) -> Bool {
        chosenAnswer == currentQuestionCorrectAnswer
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }

    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        toggleButtonsEnableProperty(to: true)
    }

    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .cancel) { [weak self] _ in
            self?.restartQuiz()
        }

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }

    private func showAnswerResult(isCorrect: Bool) {
        toggleButtonsEnableProperty(to: false)
        
        if isCorrect {
            correctAnswersCount += 1
        }

        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        if let nextQuestion = questions[safe: currentQuestionIndex + 1] {
            currentQuestionIndex += 1
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        } else {
            let text = "Ваш результат: \(correctAnswersCount) из \(questions.count)"
            let viewModel = QuizResultsViewModel(
                title: "Это раунд окончен!",
                text: text,
                buttonText: "Cыграть еще раз")
            show(quiz: viewModel)
        }
    }
    
    private func restartQuiz() {
        currentQuestionIndex = 0

        correctAnswersCount = 0

        let firstQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: firstQuestion)
        show(quiz: viewModel)
    }

    // MARK: - ViewModel

    private struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }

    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
}

// MARK: - Extensions

extension UIColor {
    static var ypGreen: UIColor {
        UIColor(named: "green" ) ?? UIColor.green
    }

    static var ypRed: UIColor {
        UIColor(named: "red" ) ?? UIColor.red
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

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
