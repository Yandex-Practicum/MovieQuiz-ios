// swiftlint:disable all

import UIKit

final class MovieQuizViewController: UIViewController {
    
    // Индекс текущего вопроса
    var currentQuestionIndex: Int = 0
    
    // Данные для текущего вопроса
    var currentQuestion: QuizQuestion { questions[currentQuestionIndex] }
    
    // Подготовленные для вывода на экран данные
    var showQuestion:  QuizStepViewModel { convert(model: currentQuestion) }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        processUserResponse(answer: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        processUserResponse(answer: false)
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        show(quiz: showQuestion)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageBorderStyle() // Настройка стиля обводки ImageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    // Структура вопроса
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    // Состояние "Вопрос задан"
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    // Состояние "Результат квиза"
    struct QuizResultViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    // Аналитика
    private struct QuizAnalytic {
        var gamesPlayed: Int = 0
        
        var score: Int = 0
        var previousGameScore: Int = 0
        var record: Int = 0
        
        var currentTime: String {
            let date = Date()
            return date.dateTimeString
        }
        var recordTime: String = ""
        
        var accuracy: String = "\(calculateAccuracy())"
        
        func calculateAccuracy(numberOfQuesions: Int) -> Float {
            print(numberOfQuesions)
            return Float(100 / numberOfQuesions * score)
        }
        
        mutating func gameOver() {
            // проверка на рекорд
            if score >= previousGameScore {
                record = score // это рекорд
                recordTime = currentTime
            } else {
                record = previousGameScore // это не рекорд
            }
            gamesPlayed += 1
        }
        
        mutating func gameWillRestart() {
            previousGameScore = score
            score = 0
        }
        
        
        
    }
    
    // Инициализируем аналитику
    private var analytic: QuizAnalytic = QuizAnalytic()
    
    // Конвертируем отдельный вопрос в модель для показа
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quiz: QuizStepViewModel = QuizStepViewModel(
            image: UIImage(named: model.image)!,
            question: model.text,
            questionNumber: "1/10")
        return quiz
    }
    
    // Заполняем фото, текст и счётчик с данными
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // Показываем следующий вопрос или результат всей викторины
    private func showNextQuestionOrResults() {
      if currentQuestionIndex == questions.count - 1 { // это последний вопрос
          showQuizResult() // показать результат квиза
      } else {
        currentQuestionIndex += 1 // это не последний вопрос
          show(quiz: showQuestion) // показать следующий вопрос
      }
    }
    
    // Показываем результат прохождения квиза
    private func show(quiz result: QuizResultViewModel) {
    }
    
    // Узнаём правильно ли ответил пользователь
    private func processUserResponse(answer: Bool) {
        if answer == questions[currentQuestionIndex].correctAnswer {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
    
    // Реагируем на правильность ответа
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            imageBorderColor(for: "correct") // меняем цвет обводки фото
            analytic.score += 1
            
        } else {
            imageBorderColor(for: "incorrect") // меняем цвет обводки фото
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageBorderColor(for: "default")
            self.showNextQuestionOrResults()
        }
    }
    
    // Действия после окончания игры
    private func gameOver() {
        currentQuestionIndex = 0 // сбросили счётчик вопросов
        show(quiz: showQuestion) // и снова показываем первый вопрос
        analytic.gameWillRestart() //
    }
    
    
    // Дефолтные стили обводки UIView
    private func imageBorderStyle() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageBorderColor(for: "default")
    }
    
    // Изменение цвета обводки в зависимости от правильности ответа
    private func imageBorderColor(for state: String) {
        switch state {
        case "correct":
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        case "incorrect":
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        default:
            imageView.layer.borderColor = UIColor.ypBlack.cgColor
        }
    }
    
    // Вывод результатов викторины
    private func showQuizResult() {
        analytic.gameOver()
        print(analytic.calculateAccuracy(numberOfQuesions: questions.count))
        let alert = UIAlertController(title: "Этот раунд окончен!",
                                      message:
                                      """
                                      Ваш результат: \(analytic.score)
                                      Количество сыгранных квизов: \(analytic.gamesPlayed)
                                      Рекорд: \(analytic.record)/10 (\(analytic.recordTime))
                                      Средняя точность: 60.00%
                                      """,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Сыграть еще раз", style: .default, handler: { _ in
            self.gameOver()
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
  
    
    
    // Массив вопросов
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
            correctAnswer: false),
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
}

extension UIColor {
    static var ypBlack: UIColor { UIColor(named: "YP Black") ?? UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1) }
    static var ypWhite: UIColor { UIColor(named: "YP White") ?? UIColor(red: 1, green: 1, blue: 1, alpha: 1) }
    static var ypGreen: UIColor { UIColor(named: "YP Green") ?? UIColor(red: 0.376, green: 0.761, blue: 0.557, alpha: 1) }
    static var ypRed: UIColor { UIColor(named: "YP Red") ?? UIColor(red: 0.961, green: 0.42, blue: 0.34, alpha: 1) }
    static var ypGray: UIColor { UIColor(named: "YP Gray") ?? UIColor(red: 0.26, green: 0.27, blue: 0.133, alpha: 1) }
    static var ypBackground: UIColor { UIColor(named: "YP Background") ?? UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0.6) }
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
 
 
 Картинка: "The Green Knight"
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: "Old"
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
