import UIKit
final class MovieQuizViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBAction func noButtonAction(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        if currentQuestion.correctAnswer == false {
            var isCorrect = true
            showAnswerResult(isCorrect: isCorrect)
        }else{
            var isCorrect = false
            showAnswerResult(isCorrect: isCorrect)
        }
    }
    @IBAction func yesButtonAction(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        if currentQuestion.correctAnswer == false {
            var isCorrect = false
            showAnswerResult(isCorrect: isCorrect)
        }else{
            var isCorrect = true
            showAnswerResult(isCorrect: isCorrect)
        }
    }
    let main = DispatchQueue.main

    var currentQuestion: QuizQuestion?
    var currentQuestionIndex: Int = 0
    var rightAnswers = 0
    var quizCount = 0
    var maxRightAnswers = 0
    var allRightAnswers = 0
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }

    private let questions = [
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма меньше, чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма меньше, чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма меньше, чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма меньше, чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма меньше, чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма меньше, чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма меньше, чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма меньше, чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма меньше, чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма меньше, чем 6?",
            correctAnswer: true)
    ]
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
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(named: model.image)!
        let question = model.text
        let totalQuestions = questions.count
        let questionNumber = "\(currentQuestionIndex + 1)/\(totalQuestions)"

        let result = QuizStepViewModel(
                image: image,
                question: question,
                questionNumber: questionNumber
        )
        return result
    }
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        if isCorrect == true{
            rightAnswers += 1
            imageView.layer.borderColor = UIColor.green.cgColor
            showNextQuestionOrResults()
        } else {
            imageView.layer.borderColor = UIColor.red.cgColor
            showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            quizCount += 1
            let viewModel = convert(model: QuizStepViewModel(image: UIImage(), question: "", questionNumber: ""))
            show(quiz: viewModel)
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                currentQuestionIndex += 1
                let question = questions[currentQuestionIndex]
                let viewModel = convert(model: question)
                show(quiz: viewModel)
          }
      }
    }
    private func convert(model: QuizStepViewModel) -> QuizResultsViewModel {
        let title = "Этот раунд окончен!"
        let buttonText = "Сыграть еще раз"
        let totalQuestions = questions.count
        let gameResult = "\(rightAnswers)/\(totalQuestions)"
        if rightAnswers > maxRightAnswers {
            maxRightAnswers = rightAnswers
            allRightAnswers += rightAnswers
        }
        var allAnswers = totalQuestions * quizCount
        let quizCount = quizCount
        let record = maxRightAnswers
        let avgAccuracy = allRightAnswers / allAnswers * 100
        let text = """
                   Ваш результат: \(gameResult)
                   Количество сыгранных квизов: \(quizCount)
                   Рекорд: \(record)
                   Средняя точность: \(avgAccuracy)%
                   """

        let result = QuizResultsViewModel(
                title: title,
                text: text,
                buttonText: buttonText)
        return result
    }
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default, handler: { [self] _ in
            print("OK button is clicked!")
        })

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }
}
