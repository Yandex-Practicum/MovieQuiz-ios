import UIKit

final class MovieQuizViewController: UIViewController {
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    // MARK: - mock data
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: false)
    ]
    
    @IBOutlet weak private var textQuestionLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var countLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preparation()
    }
    
    // MARK: - yes/no button action
    
    @IBAction private func noButtonAction(_ sender: UIButton) {
        noButtonTapped()
    }
    
    @IBAction private func yesButtonAction(_ sender: UIButton) {
        yesButtonTapped()
    }
    
    // MARK: - yes/no button logic
    
    private func noButtonTapped() {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.currentAnswer)
       }
    
    private func yesButtonTapped() {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.currentAnswer)
       }
    
    // MARK: - initial setup
    
    private func preparation() {
        imageView.layer.cornerRadius = 20
        let currentQuestion = questions[currentQuestionIndex]
        let convert = convert(model: currentQuestion)
        show(quiz: convert)
    }
    
    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questions.count - 1 {
            showResult(quiz: QuizResultsViewModel(title: "Этот раунд окончен!", text: "Ваш результат: \(correctAnswers)/10", buttonText: "Сыграть ещё раз"))
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let convert = convert(model: nextQuestion)
            show(quiz: convert)
        }
    }
    
    // MARK: - The logic of choosing an action
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }

        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.borderWidth = 8
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResult()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        countLabel.text = step.questionNumber
        textQuestionLabel.text = step.question
    }
    
    private func showResult(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            let currentQuestion = self.questions[self.currentQuestionIndex]
            let convert = self.convert(model: currentQuestion)
            self.show(quiz: convert)
            self.correctAnswers = 0
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
}

// MARK: - structures

private struct QuizQuestion {
    fileprivate let image: String
    fileprivate let text: String
    fileprivate let currentAnswer: Bool
}

private struct QuizResultsViewModel {
    fileprivate let title: String
    fileprivate let text: String
    fileprivate let buttonText: String
}

private struct QuizStepViewModel {
    fileprivate let image: UIImage
    fileprivate let question: String
    fileprivate let questionNumber: String
}
