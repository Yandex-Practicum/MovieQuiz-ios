import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    // MARK: - Private Properties
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
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
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 6
        let firstQuestions = questions[currentQuestionIndex]
        let firstQuizStepViewModel = convert(model: firstQuestions)
        show(quiz: firstQuizStepViewModel)
    }
    
    // MARK: - IB Actions
    @IBAction private func noButtonClicked() {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == givenAnswer)
    }
    
    @IBAction private func yesButtonClicked() {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == givenAnswer)
    }
    
    // MARK: - Private Methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        blockButton(isBlocked: true)
        imageView.layer.borderColor =  isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect { correctAnswers += 1 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        blockButton(isBlocked: false)
        imageView.layer.borderColor = UIColor.white.cgColor
        if currentQuestionIndex == questions.count - 1 {
            let quizResultsViewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                            text: "Ваш резульатат \(correctAnswers)/\(questions.count)",
                                                            buttonText: "Сыграть еще?")
            show(quiz: quizResultsViewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { [self] _ in
            currentQuestionIndex = 0
            correctAnswers = 0
            let firstQuestions = questions[currentQuestionIndex]
            let firstQuizStepViewModel = convert(model: firstQuestions)
            show(quiz: firstQuizStepViewModel)
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func blockButton(isBlocked: Bool) {
        noButton.isEnabled = isBlocked ? false : true
        yesButton.isEnabled = isBlocked ? false : true
    }
    
}

extension MovieQuizViewController {
    
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
}
