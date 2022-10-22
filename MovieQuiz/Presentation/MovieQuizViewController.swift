import UIKit

final class MovieQuizViewController: UIViewController {
    
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
    
    
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    
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
    
    private func show(quiz step: QuizStepViewModel) {
        
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        
        let alert = UIAlertController(title: result.title ,
                                      message: result.text ,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default, handler: { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.show(quiz: self.convert(model: self.questions[self.currentQuestionIndex]))
        })
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage() ,
                          question: model.text ,
                          questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        updateStatusButton(isActive: false)
        showAnswerResult(isCorrect: false == questions[currentQuestionIndex].correctAnswer )
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        updateStatusButton(isActive: false)
        showAnswerResult(isCorrect: true == questions[currentQuestionIndex].correctAnswer )
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        correctAnswers += isCorrect ?  1 : 0
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        
        imageView.layer.borderWidth = 0
        currentQuestionIndex += 1
        
        if currentQuestionIndex == questions.count {
            let text = "Ваш результат: \(correctAnswers) из \(questions.count)"
            show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!" , text: text, buttonText: "Сыграть еще раз"))
        } else {
            show(quiz: convert(model: questions[currentQuestionIndex]))
        }
        updateStatusButton(isActive: true)
    }
    
    private func updateStatusButton(isActive: Bool) {
        yesButton.isEnabled = isActive
        noButton.isEnabled = isActive
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        show(quiz: convert(model: questions[currentQuestionIndex]))
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
    }
    
}

