import UIKit

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

private struct QuizQuestion {
  let image: String
  let text: String
  let correctAnswer: Bool
}

private let question = "Рейтинг этого фильма больше чем 6?"

private let questionsMock: [QuizQuestion] = [
    QuizQuestion(image: "The Godfather", text: question, correctAnswer: true),
    QuizQuestion(image: "The Dark Knight", text: question, correctAnswer: true),
    QuizQuestion(image: "Kill Bill", text: question, correctAnswer: true),
    QuizQuestion(image: "The Avengers", text: question, correctAnswer: true),
    QuizQuestion(image: "Deadpool", text: question, correctAnswer: true),
    QuizQuestion(image: "The Green Knight", text: question, correctAnswer: true),
    QuizQuestion(image: "Old", text: question, correctAnswer: false),
    QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: question, correctAnswer: false),
    QuizQuestion(image: "Tesla", text: question, correctAnswer: false),
    QuizQuestion(image: "Vivarium", text: question, correctAnswer: false)
]

final class MovieQuizViewController: UIViewController {
    private let questions: [QuizQuestion] = questionsMock
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showQuestion()
    }
    
    @IBAction private func answerButtonClicked(_ sender: UIButton) {
        let isYesClicked = sender.titleLabel?.text == "Да"
        let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == isYesClicked)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        //глобально, в приложении есть баг: если быстро нажимать на кнопку "Да", то можно пройти игру без ошибок
        //это происходит потому что первые вопросы имеют ответ да, и инкрементирование счетчика происходит быстрее чем переключение вопросов (там ожидание в 1 сек)
        //ну у меня возникла идея, пока вопрос не переключился - блокировать кнопки. Лучше чем это пока не придумал)
        noButton.isEnabled = false
        yesButton.isEnabled = false
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        correctAnswers = correctAnswers + (isCorrect ? 1 : 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let result = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/\(questionsMock.count)",
                buttonText: "Сыграть ещё раз"
            )
            show(quiz: result)
        } else {
            currentQuestionIndex += 1
            showQuestion()
        }
    }
    
    private func showQuestion() {
        let question = questions[currentQuestionIndex]
        let viewModel = convert(model: question)
        show(quiz: viewModel)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        imageView.layer.borderWidth = 0
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title:result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.showQuestion()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
