import UIKit
final class MovieQuizViewController: UIViewController {
    private struct QuizQuestion{
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
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text:"Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBAction private func noButtonClicked(_ sender: Any) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        if questions[currentQuestionIndex].correctAnswer == false {
            showAnswerResult(isCorrect: true)
        }
        else {
            showAnswerResult(isCorrect: false)
        }
    }
    @IBAction private func yesButtonClicked(_ sender: Any) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        if questions[currentQuestionIndex].correctAnswer == true {
            showAnswerResult(isCorrect: true)
        }
        else {
            showAnswerResult(isCorrect: false)
        }
    }
    private func show(quiz result: QuizResultsViewModel){
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        let newStep = self.questions[self.currentQuestionIndex]
        let newQuiz = self.convert(model: newStep)
        self.show(quiz: newQuiz)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let stepViewModel = QuizStepViewModel(image:UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber:"\(currentQuestionIndex+1) / \(questions.count)")
        return stepViewModel
    }
    private func show(quiz step: QuizStepViewModel){
        self.imageView.image = step.image
        self.counterLabel.text = step.questionNumber
        self.textLabel.text = step.question
    }
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect{
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           self.showNextQuestionOrResults()
        }
    }
    private func showNextQuestionOrResults(){
        imageView.layer.borderWidth = 0
        if currentQuestionIndex == questions.count-1 {
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        }
        else {
            currentQuestionIndex += 1
            let newStep = questions[currentQuestionIndex]
            let newQuiz = convert(model: newStep)
            yesButton.isEnabled = true
            noButton.isEnabled = true
            show(quiz: newQuiz)
        }
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        self.show(quiz: convert(model: questions[0]))
        imageView.layer.cornerRadius = 20
        super.viewDidLoad()
    }
}

