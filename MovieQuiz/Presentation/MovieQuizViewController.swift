import UIKit

final class MovieQuizViewController: UIViewController {

    // переменная с индексом текущего вопроса,
    private var currentQuestionIndex: Int = 0
    // переменная со счётчиком правильных ответов
    private var correctAnswers: Int = 0
    
    
    //вывод картинки
    @IBOutlet weak private var imageView: UIImageView!
    //вывод текста
    @IBOutlet weak private var textLabel: UILabel!
    //вывод текущего номера вопроса
    @IBOutlet weak private var counterLabel: UILabel!

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        // берём текущий вопрос из массива вопросов по индексу текущего вопроса
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        
    }
    
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
       // метод красит рамку
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showNextQuestionOrResults()
            }
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 { // 1
            // идём в состояние "Результат квиза"
        } else { // 2
            currentQuestionIndex += 1
            // идём в состояние "Вопрос показан"
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        }
    }
        
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
      // Попробуйте написать код конвертации самостоятельно
        let questionStep = QuizStepViewModel( // 1
                image: UIImage(named: model.image) ?? UIImage(), // 2
                question: model.text, // 3
                questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // 4
            return questionStep
    }
    
    // вью модель для состояния "Вопрос показан"
    struct QuizStepViewModel {
      // картинка с афишей фильма с типом UIImage
      let image: UIImage
      // вопрос о рейтинге квиза
      let question: String
      // строка с порядковым номером этого вопроса (ex. "1/10")
      let questionNumber: String
    }
    
    struct QuizQuestion{
        // строка с названием фильма,
        // совпадает с названием картинки афиши фильма в Assets
        let image: String
        
        // строка с вопросом о рейтинге фильма
        let text: String
        
        // булевое значение (true, false), правильный ответ на вопрос
        let correctAnswer: Bool
    }
    private let questions: [QuizQuestion] = [
            QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?",correctAnswer: true),
            QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?",correctAnswer: true),
            QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
            QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
            QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
            QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
        ]
    
}








