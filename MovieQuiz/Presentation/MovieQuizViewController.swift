import UIKit
final class MovieQuizViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
        
    private let main = DispatchQueue.main
    
    private var currentQuestion: QuizQuestion {
        questions[currentQuestionIndex]
    }
    
    private var currentQuestionIndex: Int = 0
    private var rightAnswers = 0
    private var quizCount = 0
    private var maxRightAnswers = 0
    private var allRightAnswers = 0
    private var allAnswers = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMainImage()
    }
    
    // MARK: - Setup
    
    private func setupMainImage() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
    }
    
    // MARK: - Actions
    
    @IBAction func noButtonAction() {
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
    @IBAction func yesButtonAction() {
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
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
        guard let image = UIImage(named: model.image) else {
            return QuizStepViewModel(image: UIImage(), question: "", questionNumber: "")
        }
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
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        if isCorrect {
            rightAnswers += 1
        }
        imageView.layer.borderColor = UIColor(named: isCorrect ? "ypGreen" : "ypRed")!.cgColor
        showNextQuestionOrResults()
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            quizCount += 1
            let viewModel = convert(model: QuizStepViewModel(image: UIImage(), question: "", questionNumber: ""))
            show(quiz: viewModel)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                guard currentQuestionIndex < questions.count - 1 else { return }
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
        
        if quizCount == 0 {
            allAnswers = totalQuestions + 1
        } else {
            allAnswers = totalQuestions * quizCount
        }
        
        let quizCount = quizCount
        let record = maxRightAnswers
        let avgAccuracy = Int(round(Float(allRightAnswers) / Float(allAnswers) * 100))
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

    private func restartQuiz() {
        currentQuestionIndex = 0
        rightAnswers = 0
        let question = questions[currentQuestionIndex]
        let viewModelStart = convert(model: question)
        show(quiz: viewModelStart)
    }

    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                message: result.text,
                preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default, handler: {_ in self.restartQuiz() })
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
}

