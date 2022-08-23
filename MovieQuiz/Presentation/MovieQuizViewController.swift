// my project
// swiftlint: disable all

import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var questionNumber: UILabel!
    
    // MARK: - Actions
    
    @IBAction private func noButtonAction(_ sender: Any) {
        showAnswerResult(answer: false)
        // , question: questions[currentQuestionIndex])
    }
    @IBAction private func yesButtonAction(_ sender: Any) {
        showAnswerResult(answer: true)
        // , question: questions[currentQuestionIndex])
    }
    
    
    // MARK: - Properties
    
    private let questions: [QuizQuestion] = DataSource.mockQuestions
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion?
    private var gamesScore: QuizScores = QuizScores()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        showQuestion()
    }
    
    // MARK: - Business Logic
    
    private func showQuestion() {
        /// Установили текущий вопрос. Так как у нас квиз начинается с 1го вопроса,
        /// то и берем из массива вопросов 1й элемент
        currentQuestion = questions[safe: currentQuestionIndex] // метод лежит в Array+Extensions
        
        /// Разворачиваем опциональный вопрос, который брали безопасным сбособом из массива по индексу
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        /// Создаем первый шаг квиза при помощи метода `convert`
        let questionViewModel = convert(model: currentQuestion)
        
        /// Показываем первый шаг
        show(quiz: questionViewModel)
    }
    
    // MARK: - Helpers
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.image = step.image
        questionLabel.text = step.question
        questionNumber.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        showResultAlert(result: result)
    }
    
    private func correctAnswerCounter() {
        gamesScore.score += 1
    }
    
    private func showAnswerResult(answer: Bool)
    
    {
        guard let currentQuestion = currentQuestion else { return }
        
        let isCorrect = (answer == currentQuestion.correctAnswer)
        let greenColor = UIColor(named: "Green") ?? .green
        let redColor = UIColor(named: "Red") ?? .red
        let borderColor = isCorrect ? greenColor : redColor
        
        if answer == currentQuestion.correctAnswer {
            gamesScore.score += 1
            
        } else {}
        
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = borderColor.cgColor // делаем рамку зеленой
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
            
        }
    }
    
    private func showNextQuestionOrResults() {
        // - 1 потому что индекс начинается с 0, а длинна массива — с 1
        if currentQuestionIndex == questions.count - 1 {
            print("Пора показать результат")
            gamesScore.itIsRecord() // проверяем рекорд ли это
            if gamesScore.score == 10 {
                let winResult = QuizResultsViewModel (
                    title: "Вы выиграли!",
                    text:  """
                    Ваш результат: \(gamesScore.score)/\(questions.count)
                    Количество сыгранных квизов: \(gamesScore.gamesPlayed)
                    Рекорд: \(gamesScore.record)/\(questions.count) (\(gamesScore.recordTime))
                    Средняя точность: \(gamesScore.accuracyAverage())%
                    """,
                    buttonText: "Сыграть еще раз"
                )
                show(quiz: winResult)
                
            } else {
                
                let result = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text:
                    """
                    Ваш результат: \(gamesScore.score)/\(questions.count)
                    Количество сыгранных квизов: \(gamesScore.gamesPlayed)
                    Рекорд: \(gamesScore.record)/\(questions.count) (\(gamesScore.recordTime))
                    Средняя точность: \(gamesScore.accuracyAverage())%
                    """,
                    buttonText: "Сыграть еще раз"
                )
                show(quiz: result)
            }
            // создаём объекты всплывающего окна
            // показать результат квиза
            
        } else {
            
            // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
            currentQuestionIndex += 1
            showQuestion() // показать следующий вопрос
        }
    }
    
    private func restart() {
        currentQuestionIndex = 0 // Сбросил вопрос на первый
        gamesScore.restartQuiz()
        showQuestion()
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? .remove,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }
    
    // MARK: - Alert
    
    func showResultAlert (result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title, // заголовок всплывающего окна
                                      message: result.text, /* текст во всплывающем окне */
                                      preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet
        
        // создаём для него кнопки с действиями
        let action = UIAlertAction(
            title: "Сыграть ещё раз",
            style: .default, handler: { _ in
                print("Игра началась заново")
                self.restart() // заново запускаем квиз с номера 1
            })
        
        // добавляем в алерт кнопки
        alert.addAction(action)
        
        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data Source
    
    enum DataSource {
        static let mockQuestions: [QuizQuestion] = [
            QuizQuestion(
                image: "The Green Knight",
                text: "Рейтинг этого фильма больше, чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Deadpool",
                text: "Рейтинг этого фильма больше, чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Old",
                text: "Рейтинг этого фильма больше, чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "The Ice Age Adventures of Buck Wild",
                text: "Рейтинг этого фильма больше, чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "Tesla",
                text: "Рейтинг этого фильма больше, чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "Vivarium",
                text: "Рейтинг этого фильма больше, чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "The Avengers",
                text: "Рейтинг этого фильма больше, чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Kill Bill",
                text: "Рейтинг этого фильма больше, чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Dark Knight",
                text: "Рейтинг этого фильма больше, чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Godfather",
                text: "Рейтинг этого фильма больше, чем 6?",
                correctAnswer: true)
        ]
    }
}
