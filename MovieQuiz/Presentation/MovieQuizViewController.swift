import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak private var indexLabel: UILabel!
    @IBOutlet weak private var questionLabel: UILabel!
    
    @IBOutlet weak private var previewImage: UIImageView!
    
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    // MARK: - Private Properties
    private var currentQuestionIndex = 0 // индекс текущего вопроса
    private var correctAnswers = 0 // счетчик правильных ответов
    
    // вью модель для состояния "Вопрос показан"
    struct QuizStepViewModel {
        let image: UIImage // картинка с афишей фильма с типом UIImage
        let question: String // вопрос о рейтинге квиза
        let questionNumber: String // строка с порядковым номером этого вопроса (ex. "1/10")
    }
    
    // структура данных для массива вопросов
    struct QuizQuestion {
        let image: String // название фильма / картинки
        let text: String // вопрос по фильму
        let correctAnswer: Bool // правильный ответ на вопрос Да / Нет
    }
    
    // массив вопросов
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
    
    // массив вопросов в рандомном порядке
    private var questions_: [QuizQuestion] = []
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsRandomizer()
        let firstQuestion = convert(model: questions_[0])
        show(quiz: firstQuestion)
        
    }
    
    // MARK: - IB Actions
    // обработка нажатия кнопки НЕТ
    @IBAction private func noButtonDidTapped(_ sender: Any) {
    }
    
    // обработка нажатия кнопки ДА
    @IBAction private func yesButtonDidTapped(_ sender: Any) {
    }
    
    // MARK: - Private Methods
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let currentStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return currentStep
    }
    
    // метод вывода на экран текущего вопроса
    private func show(quiz step: QuizStepViewModel) {
        indexLabel.text = step.questionNumber
        previewImage.image = step.image
        questionLabel.text = step.question
    }
    
    // функция заполнения массива вопросов в рандомном порядке
    private func questionsRandomizer() {
        questions_ = questions.shuffled()
    }
    
}

