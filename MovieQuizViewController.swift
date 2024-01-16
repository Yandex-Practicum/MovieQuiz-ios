import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        show(quiz: convert(model: questions[currentQuestionIndex]))
    }
    
    private func setAnswerButtonsEnabled(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var noButton: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
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
    
    private struct QuizErrorViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
    ]
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1) / 10")
    }
    
    private func checkResultAnswer(isCorrect: Bool) -> Bool {
        if isCorrect == questions[currentQuestionIndex].correctAnswer {
            correctAnswers += 1
            return true
        }
        return false
    }
    
    private func startNewRound() {
        currentQuestionIndex = 0
        correctAnswers = 0
        setAnswerButtonsEnabled(true)
        show(quiz: convert(model: self.questions[currentQuestionIndex]))
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!", text: "Ваш результат \(correctAnswers) / 10", buttonText: "Сыграть ещё раз"))
        } else {
            UIView.transition(with: self.view, duration: 2.0, options: .transitionCurlUp, animations: {
                self.currentQuestionIndex += 1
                self.setAnswerButtonsEnabled(true)
                self.show(quiz: self.convert(model: self.questions[self.currentQuestionIndex]))
            }, completion: nil)
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        showAlert(title: result.title, message: result.text, textButton: result.buttonText)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showAlert(title p1: String, message p2: String, textButton p3: String) {
        let alert = UIAlertController(title: p1,
                                      message: p2,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: p3, style: .default) { _ in
            self.startNewRound()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setAnswerButtonEnabled(_ enabled: Bool) {
        noButton.isEnabled = enabled
        yesButton.isEnabled = enabled
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        setAnswerButtonEnabled(false)
        showAnswerResult(isCorrect: checkResultAnswer(isCorrect: false))
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        setAnswerButtonEnabled(false)
        showAnswerResult(isCorrect: checkResultAnswer(isCorrect: true))
    }
}
