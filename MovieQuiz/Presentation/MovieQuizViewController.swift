import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Struct's
    // для состояния "Вопрос показан"
    struct QuizStepViewModel {
        // картинка с афишей фильма с типом UIImage
      let image: UIImage
        // вопрос о рейтинге квиза
      let question: String
        // строка с порядковым номером этого вопроса (ex. "1/10")
      let questionNumber: String
    }
    
    // для состояния "Результат квиза"
    struct QuizResultsViewModel {
      let title: String
      let text: String
      let buttonText: String
    }
    
    struct QuizQuestion {
      // строка с названием фильма,
      // совпадает с названием картинки афиши фильма в Assets
      let image: String
      // строка с вопросом о рейтинге фильма
      let text: String
      // булевое значение (true, false), правильный ответ на вопрос
      let correctAnswer: Bool
    }
    // MARK: - Mock - данные
    private let questions: [QuizQuestion] = [
            QuizQuestion(
                image: "Kill Bill",
                text: "Рейтинг этого фильма больше чем 2?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Dark Knight",
                text: "Рейтинг этого фильма больше чем 3?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Godfather",
                text: "Рейтинг этого фильма больше чем 4?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Avengers",
                text: "Рейтинг этого фильма больше чем 5?",
                correctAnswer: true),
            QuizQuestion(
                image: "Deadpool",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Green Knight",
                text: "Рейтинг этого фильма больше чем 7?",
                correctAnswer: true),
            QuizQuestion(
                image: "Old",
                text: "Рейтинг этого фильма больше чем 8?",
                correctAnswer: false),
            QuizQuestion(
                image: "The Ice Age Adventures of Buck Wild",
                text: "Рейтинг этого фильма больше чем 9?",
                correctAnswer: false),
            QuizQuestion(
                image: "Tesla",
                text: "Рейтинг этого фильма больше чем 10?",
                correctAnswer: false),
            QuizQuestion(
                image: "Vivarium",
                text: "Рейтинг этого фильма больше чем 11?",
                correctAnswer: false)
        ]
    // MARK: - Properties
    // переменная с индексом текущего вопроса, начальное значение 0
    // (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
    private var currentQuestionIndex = 0
    // переменная со счётчиком правильных ответов, начальное значение закономерно 0
    private var correctAnswer = 0
    // MARK: - IBOutlet
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    // MARK: - UIKit
    override func viewDidLoad() {
        super.viewDidLoad()
        // берём текущий вопрос из массива вопросов по индексу текущего вопроса
        let currentQuestion = questions[currentQuestionIndex]
        let quizStep = convert(model: currentQuestion)
        show(quiz: quizStep)
    }
    //MARK: - IBActions
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    //MARK: - Private functions
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки

    }
    
}
