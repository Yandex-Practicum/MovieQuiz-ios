import UIKit

final class MovieQuizViewController: UIViewController {
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
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        let result = currentQuestion!.correctAnswer == true
        showAnswerResult(isCorrect: result)
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        let result = currentQuestion!.correctAnswer == false
        showAnswerResult(isCorrect: result)
    }
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var currentQuestion: QuizQuestion? = nil
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        renderQuestion(currentIndex: currentQuestionIndex)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage.init(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex+1)/\(questions.count)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.image = step.image
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageWithBorder(result: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
           // код, который мы хотим вызвать через 1 секунду
            showNextQuestionOrResults()
        }
    }
    
    private func renderQuestion(currentIndex: Int){
        currentQuestion = questions[currentIndex]
        let quizStepViewModel = convert(model: currentQuestion!)
        show(quiz: quizStepViewModel)
    }
    
    private func imageWithBorder(result: Bool) {
        let color = result ? UIColor.ypGreen : UIColor.ypRed
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = color.cgColor
        imageView.layer.cornerRadius = 20.0
        imageView.layer.borderWidth = 8
    }
    
    private func showNextQuestionOrResults() {
        currentQuestionIndex+=1
        renderQuestion(currentIndex: currentQuestionIndex)
    }
}

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

extension UIImage {
    
}

