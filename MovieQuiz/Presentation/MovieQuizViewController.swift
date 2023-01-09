import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var questionNumberLabel: UILabel!
    @IBOutlet private weak var filmPosterImageView: UIImageView!
    @IBOutlet private weak var questionTextLabel: UILabel!
    
    @IBAction private func noButtonPressed(_ sender: UIButton) {
        givenAnswer = false
        showAnswerResult(isAnswerCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonPressed(_ sender: UIButton) {
        givenAnswer = true
        showAnswerResult(isAnswerCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    //MARK: - ViewModels
    
    // Модель и Моск данные с вопросами
    private struct QuizQuestionModel {
      let image: String
      let text: String
      let correctAnswer: Bool
    }
    
    private var questions: [QuizQuestionModel] = [
            QuizQuestionModel(
                image: "The Godfather",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestionModel(
                image: "The Dark Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestionModel(
                image: "Kill Bill",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestionModel(
                image: "The Avengers",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestionModel(
                image: "Deadpool",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestionModel(
                image: "The Green Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestionModel(
                image: "Old",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestionModel(
                image: "The Ice Age Adventures of Buck Wild",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestionModel(
                image: "Tesla",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestionModel(
                image: "Vivarium",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false)
        ]
    
    // Модель для состояния "Вопрос показан на экран"
    private struct QuizStepViewModel {
      let image: UIImage
      let question: String
      let questionNumber: String
    }

    // Модель для состояния "Результат квиза"
    private struct QuizResultsViewModel {
      let title: String
      let text: String
      let buttonText: String
    }
    
    // Вспомогательная переменная для вычисления результата ответа
    private lazy var givenAnswer = false
    
    // Вспомогательная переменная для вычисления номера вопроса
    private var currentQuestionIndex = 0
    
    // Вспомогательная переменная для вычисления самого вопроса
    
    private lazy var currentQuestion = questions[currentQuestionIndex]
   
    // MARK: - VC life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstQuestion = convert(model: currentQuestion)
        show(quiz: firstQuestion)
    }
    
    // MARK: - Methods
    
    private func show(quiz step: QuizStepViewModel) {
        self.filmPosterImageView.image = step.image
        self.questionTextLabel.text = step.question
        self.questionNumberLabel.text = "\(currentQuestionIndex + 1)/\(questions.count)"
    }

    private func show(quiz result: QuizResultsViewModel) {
      // здесь мы показываем результат прохождения квиза
    }
    
    private func convert(model: QuizQuestionModel) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    private func createBoundsForAnswer (with color: UIColor) {
        filmPosterImageView.layer.masksToBounds = true
        filmPosterImageView.layer.borderWidth = 8
        filmPosterImageView.layer.borderColor = color.cgColor
    }
    
    private func showAnswerResult(isAnswerCorrect: Bool) {
        if isAnswerCorrect {
            createBoundsForAnswer(with: UIColor(named: "YP Green (iOS)") ?? UIColor.green)
        } else {
            createBoundsForAnswer(with: UIColor(named: "YP Red (iOS)") ?? UIColor.red)
        }
    }
}
