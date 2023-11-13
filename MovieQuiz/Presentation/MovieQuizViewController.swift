import UIKit
//Порядок - переменные, overrides+inits, методы, outlets+actions
final class MovieQuizViewController: UIViewController {
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 7.5?",
            isAnswerCorrect: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма меньше чем 7.5?",
            isAnswerCorrect: false),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 8?",
            isAnswerCorrect: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма меньше чем 7.8?",
            isAnswerCorrect: false),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма меньше чем 7.3?",
            isAnswerCorrect: false),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6.7?",
            isAnswerCorrect: false),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма меньше чем 5.9?",
            isAnswerCorrect: true),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма меньше чем 5.5?",
            isAnswerCorrect: true),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма меньше чем 5.5?",
            isAnswerCorrect: true),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            isAnswerCorrect: false)
    ]
    private var indexOfCurrentQuestion = 0
    private var countOfCorrectAnswers = 0
    struct QuizQuestion {
        let image: String
        let text: String
        let isAnswerCorrect: Bool
    }
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    struct QuizResultsViewModel {
        let alertName: String
        let resultText: String
        let repeatButtonText: String
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let firstQuestion = questions.first else {
            return
        }
        imageView.layer.cornerRadius = 20
        let firstQuestionView = convert(model: firstQuestion)
        self.showQuestion(quiz: firstQuestionView)
    }
    private func showQuestion(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        buttonNo.isEnabled = true
        buttonYes.isEnabled = true
    }
    private func showAlert(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.alertName,
            message: result.resultText,
            preferredStyle: .alert)
        let action = UIAlertAction(title: result.repeatButtonText, style: .default) { _ in
            self.countOfCorrectAnswers = 0
            self.indexOfCurrentQuestion = 0
            let firstQuestion = self.questions[self.indexOfCurrentQuestion]
            let firstQuestionView = self.convert(model: firstQuestion)
            self.showQuestion(quiz: firstQuestionView)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quizStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(indexOfCurrentQuestion+1) / \(questions.count)")
        return quizStep
    }
    private func showNextQuestionOrResults() {
        if indexOfCurrentQuestion == questions.count - 1 {
            let userResultText = "Your result is \(countOfCorrectAnswers)/10!"
            let answerViewModel = QuizResultsViewModel(
                alertName: "End of round!",
                resultText: userResultText,
                repeatButtonText: "Play again?")
            showAlert(quiz: answerViewModel)
            imageView.layer.borderWidth = 0
            imageView.layer.borderColor = UIColor.clear.cgColor
        } else {
            indexOfCurrentQuestion+=1
            let nextQuestion = questions[indexOfCurrentQuestion]
            let newViewModel = convert(model: nextQuestion)
            showQuestion(quiz: newViewModel)
            imageView.layer.borderWidth = 0
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    private func showAnswerResult(isCorrect: Bool) {
        buttonNo.isEnabled = false
        buttonYes.isEnabled = false
        if isCorrect {
            countOfCorrectAnswers+=1
        }
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 8
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    @IBOutlet private weak var buttonNo: UIButton!
    @IBOutlet private weak var buttonYes: UIButton!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[indexOfCurrentQuestion]
        let userAnswer = false
        showAnswerResult(isCorrect: userAnswer == currentQuestion.isAnswerCorrect)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[indexOfCurrentQuestion]
        let userAnswer = true
        showAnswerResult(isCorrect: userAnswer == currentQuestion.isAnswerCorrect)
    }
}
/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 7.5??
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма меньше чем 7.5?
 Ответ: НЕТ
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 8?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма меньше чем 7.8?
 Ответ: НЕТ
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма меньше чем 7.3?
 Ответ: НЕТ
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6.7?
 Ответ: НЕТ
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма меньше чем 5.9?
 Ответ: ДА
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма меньше чем 5.5?
 Ответ: ДА
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма меньше чем 5.5?
 Ответ: ДА
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */

