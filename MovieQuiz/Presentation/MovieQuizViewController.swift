import UIKit

private struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

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

final class MovieQuizViewController: UIViewController {

    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!

    private var currentQuestionIndex = 0
    private var correctAnswers = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        showFirstTime()
    }

    @IBAction private func yesButtonClicked(_ sender: Any) {
        showAnswerResult(
            isCorrect:
                questions[currentQuestionIndex].correctAnswer == true)
    }

    @IBAction private func noButtonClicked(_ sender: Any) {
        showAnswerResult(
            isCorrect:
                questions[currentQuestionIndex].correctAnswer == false)
    }

    private func show(quiz step: QuizStepViewModel) {
        configureImageLayer(thickness: 0, color: UIColor.ypWhite)
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }

    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)

        let action = UIAlertAction(title: result.buttonText, style: .default) {_ in
            self.showFirstTime()
        }

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }

    private func showFirstTime() {
        currentQuestionIndex = 0
        correctAnswers = 0
        self.show(quiz: self.createStepViewModel(index: self.currentQuestionIndex))
    }

    private func showFinalResult() {
        let text = "Ваш результат: \(correctAnswers) из \(questions.count)"
        let viewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: text,
            buttonText: "Сыграть ещё раз")
        show(quiz: viewModel)
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == (questions.count - 1) {
            currentQuestionIndex = 0
            showFinalResult()
        } else {
            currentQuestionIndex += 1
            show(quiz: convert(model: questions[currentQuestionIndex]))
        }
    }

    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
            configureImageLayer(thickness: 8, color: UIColor.ypGreen)
        }
        else {
            configureImageLayer(thickness: 8, color: UIColor.ypRed)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }

    private func configureImageLayer(thickness: Int, color: UIColor) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = CGFloat(thickness)
        imageView.layer.borderColor = color.cgColor
        imageView.layer.cornerRadius = 15
    }

    private func createStepViewModel(index: Int) -> QuizStepViewModel {
        if index < 0 || index >= questions.count {
            return convert(model: QuizQuestion(
                image: "",
                text: "Неправильное значение индекса (\(index))",
                correctAnswer: questions[index].correctAnswer))
        }
        return convert(model: QuizQuestion(
            image: questions[index].image,
            text: questions[index].text,
            correctAnswer: questions[index].correctAnswer))
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }

}
