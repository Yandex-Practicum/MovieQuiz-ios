import UIKit

final class MovieQuizViewController: UIViewController {
   
    //Properties
    private var currentQuestionIndex = 0
   
    private var correctAnswers = 0
   
    private let questions: [QuizQuestion] = [
    QuizQuestion(image: "The Godfather",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "The Dark Knight",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "Kill Bill",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "The Avengers",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "Deadpool",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "The Green Knight",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "Old",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: false),
    QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: false),
    QuizQuestion(image: "Tesla",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: false),
    QuizQuestion(image: "Vivarium",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: false)]
    
    //outlets
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var questionTextLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showNextQuestion()
    }
    
    //actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
    checkAnswerAndShowNextQuestion(answer: false)}
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
    checkAnswerAndShowNextQuestion(answer: true)}
    
    //private methods
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionTextLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel { //метод конвертации, который принимает моковый вопрос и возвращает вью модель для главного экрана
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),//Инициализируем картинку с помощью конструктора UIImage(named: )
            question: model.text, //забираем уже готовый вопрос из мокового вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    private func showNextQuestion() {
        guard currentQuestionIndex < questions.count else { //Если условие currentQuestionIndex < questions.count не выполняется, то это означает, что все вопросы уже                                                      были показаны, и выполнение метода завершится
            return
        }
        let question = questions[currentQuestionIndex]
        let questionStep = convert(model: question)
        show(quiz: questionStep)
    }
    
    
    private func checkAnswerAndShowNextQuestion(answer: Bool) {
        let currentQuestion = questions[currentQuestionIndex]
        if answer == currentQuestion.correctAnswer {
            correctAnswers += 1
        }
        currentQuestionIndex += 1
        showNextQuestion()
    }
}

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

struct QuizStepViewModel { // вью модель для состояния "Вопрос показан"
    let image: UIImage
    let question: String
    let questionNumber: String
}
struct QuizResultsViewModel { // для состояния "Результат квиза"
    let title: String
    let text: String
    let buttonText: String
}

































/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
