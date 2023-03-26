import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    private var isDelay: Bool = false
    
    private struct QuizStepViewModel {
      let image: UIImage
      let question: String
      let questionNumber: String
    }
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
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
                correctAnswer: false)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nextQuestion = questions[currentQuestionIndex]
        let ViewModel = convert(model: nextQuestion)
        show(quiz: ViewModel)
    }
    
    
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
    
    
    private func showResult(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) {_ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let currentQuestion = self.questions[self.currentQuestionIndex]
            let ViewModel = self.convert(model: currentQuestion)
            self.show(quiz: ViewModel)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func showAnswerResult(isCorrect: Bool) {
        self.isDelay = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor: UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
        if isCorrect {
               correctAnswers += 1
           }
    }
    
    
    private func showNextQuestionOrResults() {
        isDelay = false
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/10"
            let ViewModel: QuizResultsViewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                                            text: text,
                                                                            buttonText: "Сыграть еще раз")
            showResult(quiz: ViewModel)
        }
        else{
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let ViewModel = convert(model: nextQuestion)
            show(quiz: ViewModel)
        }
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        if isDelay == false {
            let currentQuestion = questions[currentQuestionIndex]
            let givenAnswer = true
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    }
    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        if isDelay == false {
            let currentQuestion = questions[currentQuestionIndex]
            let givenAnswer = false
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    }
}



