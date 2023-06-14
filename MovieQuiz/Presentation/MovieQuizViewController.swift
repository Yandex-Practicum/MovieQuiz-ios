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
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
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
        yesButton.isEnabled = false
        noButton.isEnabled = false
        imageWithBorder(result: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            showNextQuestionOrResults()
        }
    }
    
    private func renderQuestion(currentIndex: Int){
        imageView.layer.cornerRadius = 20.0
        imageView.layer.borderWidth = 0
        currentQuestion = questions[currentIndex]
        let quizStepViewModel = convert(model: currentQuestion!)
        show(quiz: quizStepViewModel)
    }
    
    private func imageWithBorder(result: Bool) {
        if (result) {
            correctAnswers += 1
        }
        let color: UIColor = result ? .ypGreen : .ypRed
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = color.cgColor
        imageView.layer.cornerRadius = 20.0
        imageView.layer.borderWidth = 8
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let quizResultsViewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: "Ваш результат: \(correctAnswers)/\(questions.count)", buttonText: "Сыграть еще раз")
            show(quiz: quizResultsViewModel)
        } else {
            currentQuestionIndex += 1
            yesButton.isEnabled = true
            noButton.isEnabled = true
            renderQuestion(currentIndex: currentQuestionIndex)
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
        
                self.renderQuestion(currentIndex: self.currentQuestionIndex)
            }
            alert.addAction(action)
        
            self.present(alert, animated: true, completion: nil)
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

struct QuizResultsViewModel {
  
  let title: String
  
  let text: String
  
  let buttonText: String
}

