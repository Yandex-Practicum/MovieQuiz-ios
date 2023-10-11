import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        show(quiz: convert(model: questions[currentQuestion]))
    }
    
    struct QuizQuestion {
        let filmName: String
        let rating: Float
        let text: String
        let answer: Bool
    }
    
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    private var currentQuestion: Int = 0
    private var correctAnswers: Int = 0


    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textView: UILabel!
    @IBOutlet private weak var indexView: UILabel!
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(filmName: "The Godfather", rating: 9.2, text: "Рейтинг этого фильма больше чем 6?", answer: true),
        QuizQuestion(filmName: "The Dark Knight", rating: 8.1, text: "Рейтинг этого фильма больше чем 6?", answer: true),
        QuizQuestion(filmName: "Kill Bill", rating: 8.1, text: "Рейтинг этого фильма больше чем 6?", answer: true),
        QuizQuestion(filmName: "The Avengers", rating: 8.0, text: "Рейтинг этого фильма больше чем 6?", answer: true),
        QuizQuestion(filmName: "Deadpool", rating: 8.0, text: "Рейтинг этого фильма больше чем 6?", answer: true),
        QuizQuestion(filmName: "The Green Knight", rating: 6.6, text: "Рейтинг этого фильма больше чем 6?", answer: true),
        QuizQuestion(filmName: "Old", rating: 5.8, text: "Рейтинг этого фильма больше чем 6?", answer: false),
        QuizQuestion(filmName: "The Ice Age Adventures of Buck Wild", rating: 4.3, text: "Рейтинг этого фильма больше чем 6?", answer: false),
        QuizQuestion(filmName: "Tesla", rating: 5.1, text: "Рейтинг этого фильма больше чем 6?", answer: false),
        QuizQuestion(filmName: "Vivarium", rating: 5.8, text: "Рейтинг этого фильма больше чем 6?", answer: false)
    ]
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.filmName) ?? UIImage(), question: model.text,
                                 questionNumber: "\(currentQuestion + 1)/\(questions.count)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textView.text = step.question
        indexView.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        if isCorrect { correctAnswers += 1 }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }

    }
    
    private func showNextQuestionOrResults(){
        if currentQuestion == questions.count - 1{
            let alert = UIAlertController(
                title: "Этот раунд окончен!",
                message: "Ваш результат \(correctAnswers) из \(questions.count)",
                preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                self.currentQuestion = 0
                self.correctAnswers = 0
                self.yesButton.isEnabled = true
                self.noButton.isEnabled = true
                let viewModel = self.convert(model: self.questions[self.currentQuestion])
                self.show(quiz: viewModel)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        } else {
            currentQuestion += 1
            let newViewModel = convert(model: questions[currentQuestion])
            show(quiz: newViewModel)
            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
    }
    
    @IBAction private func noButton(_ sender: Any) {
        showAnswerResult(isCorrect: questions[currentQuestion].answer == false)
    }
    
    @IBAction private func yesButton(_ sender: Any) {
        showAnswerResult(isCorrect: questions[currentQuestion].answer == true)
    }
}


