// swiftlint:disable all

import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    private let questionFactory = QuestionFactory()
    private let questionsAmount: Int = 10
    
    private var currentQuestion: QuizQuestion?
    private var currentQuestionCounter: Int = 0
    private var analytic = QuizAnalytics()
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        processUserAnswer(answer: false)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        processUserAnswer(answer: true)
    }
    
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let firstQuestion = questionFactory.requestNextQuestion() {
            currentQuestion = firstQuestion
            let viewModel = convert(model: firstQuestion)
            show(quiz: viewModel)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageBorderDefaultStyle() // Настройка стиля обводки ImageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    // MARK: - QUIZ STEP
    
    // Конвертор данных вопроса в данные для заполнения вью
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quiz = QuizStepViewModel(
            image: UIImage(named: model.image)!, // TODO: подставить дефолтную картинку
            question: model.text,
            questionNumber: "\(currentQuestionCounter + 1)/\(questionsAmount)")
        return quiz
    }
    
    // Вывод данных на экран
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    
    // MARK: - QUIZ RESULT
    
    // Вывод данных на экран
    private func show(quiz result: QuizResultViewModel) {
        showResultAlert(result: result)
    }
    
    
    // MARK: - ANSWER RESULT
    
    // Вывод на экран рамки для фото в зависимости от правильности
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            imageBorderColor(for: "correct")
            
        } else {
            imageBorderColor(for: "incorrect")
        }
    }
    
    
    // MARK: - QUIZ BRAIN
    
    // Определяю правильность ответа
    private func processUserAnswer(answer: Bool) {
        
        if let currentQuestion = currentQuestion {
            if answer == currentQuestion.correctAnswer {
                showAnswerResult(isCorrect: true)
                analytic.score += 1 // Записал успешный результат
            } else {
                showAnswerResult(isCorrect: false)
            }
            buttonsEnabled(is: false) // временно отключил кнопки
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.imageBorderDefaultStyle()
                self.showNextQuestionOrResults()
                self.buttonsEnabled(is: true) // включил кнопки
            }
        }
        
    }
    
    // Показываем следующий вопрос или результат всей викторины
    private func showNextQuestionOrResults() {
        if currentQuestionCounter == questionsAmount - 1 { // это последний вопрос
            analytic.isItRecord() // Проверил на рекорд
            if analytic.score == 10 {
                // Статистика для победителя - 10 из 10 правильных ответов
                let winResult = QuizResultViewModel(
                    title: "Вы выиграли!",
                    text:
                    """
                    Ваш результат: \(analytic.score)/\(questionsAmount)
                    Количество сыгранных квизов: \(analytic.gamesPlayed)
                    Рекорд: \(analytic.record) /\(questionsAmount) (\(analytic.recordTime))
                    Средняя точность: \(analytic.accuracyAverage())%
                    """,
                    buttonText: "Сыграть еще раз"
                )
                show(quiz: winResult)
            } else {
                // Статистика
                let result = QuizResultViewModel(
                    title: "Этот раунд окончен!",
                    text:
                    """
                    Ваш результат: \(analytic.score)/\(questionsAmount)
                    Количество сыгранных квизов: \(analytic.gamesPlayed)
                    Рекорд: \(analytic.record) /\(questionsAmount) (\(analytic.recordTime))
                    Средняя точность: \(analytic.accuracyAverage())%
                    """,
                    buttonText: "Сыграть еще раз"
                )
                show(quiz: result)
            }
        } else { // это не последний вопрос
            currentQuestionCounter += 1
            if let nextQuestion = questionFactory.requestNextQuestion() {
                currentQuestion = nextQuestion
                let viewModel = convert(model: nextQuestion)
                show(quiz: viewModel)
            }
        }
    }
    
    // Делаю кнопки "да" и "нет" активными или нет по необходимости
    private func buttonsEnabled(is state: Bool) {
        if state {
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        } else {
            self.yesButton.isEnabled = false
            self.noButton.isEnabled = false
        }
    }
    
    private func restart() {
        currentQuestionCounter = 0 // Сбросил вопрос на первый
        analytic.gameRestart()
        viewDidLoad()
    }

}


// MARK: - CLASS EXTENSIONS

// НАСТРОЙКА ЦВЕТОВ
extension UIColor {
    static var ypBlack: UIColor { UIColor(named: "YP Black") ?? UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1) }
    static var ypWhite: UIColor { UIColor(named: "YP White") ?? UIColor(red: 1, green: 1, blue: 1, alpha: 1) }
    static var ypGreen: UIColor { UIColor(named: "YP Green") ?? UIColor(red: 0.376, green: 0.761, blue: 0.557, alpha: 1) }
    static var ypRed: UIColor { UIColor(named: "YP Red") ?? UIColor(red: 0.961, green: 0.42, blue: 0.34, alpha: 1) }
    static var ypGray: UIColor { UIColor(named: "YP Gray") ?? UIColor(red: 0.26, green: 0.27, blue: 0.133, alpha: 1) }
    static var ypBackground: UIColor { UIColor(named: "YP Background") ?? UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0.6) }
}

// НАСТРОЙКА СТИЛЕЙ ОБВОДКИ ИМИДЖА
extension MovieQuizViewController {
    
    // Дефолтные стили обводки UIView
    private func imageBorderDefaultStyle() {
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
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
}

// НАСТРОЙКИ АЛЕРТА ДЛЯ РЕЗУЛЬТАТА КВИЗА
extension MovieQuizViewController {
    private func showResultAlert(result: QuizResultViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default, handler: { _ in
            self.restart()
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

// СБОРЩИК АНАЛИТИКИ
extension MovieQuizViewController {
    
    private struct QuizAnalytics {
        var gamesPlayed: Int = 1
        var score: Int = 0
        var record: Int = 0
        
        var currentTime: String {
            let date = Date()
            return date.dateTimeString
        }
        var recordTime: String = ""
        let numberOfQuestions = 10 // Не придумал как увидеть отсюда длину массива вопросов
        var accuracyCurrent: Float = 0 // Точность только закончившегося квиза
        var accuracyCollect: Float = 0 // Суммарная точность всех квизов, который были завершены раньше
        
        mutating func accuracyAverage() -> String {
            // Вычисление средней точности всех квизов
            accuracyCurrent = Float(100 / numberOfQuestions * score)
            accuracyCollect += accuracyCurrent
            return String(format: "%.2f", accuracyCollect / Float(gamesPlayed))
        }

        mutating func isItRecord() {
            // проверка на рекорд
            if score >= record {
                record = score // это рекорд
                recordTime = currentTime
            }
        }
        
        mutating func gameRestart() {
            gamesPlayed += 1
            score = 0
        }

    }
    
}
