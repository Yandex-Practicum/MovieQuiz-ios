import UIKit

final class MovieQuizViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // настраиваем внешний вид рамки
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        show(quiz: convert(model: questions[currentQuestionIndex]))
    }
    
    // связь объектов из main с контроллером
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    // переменная с индексом текущего вопроса, начальное значение 0
    private var currentQuestionIndex = 0
    // переменная со счётчиком правильных ответов, начальное значение закономерно 0
    private var correctAnswers = 0

    // структура самого вопроса
    private struct QuizQuestion {
      let image: String
      let text: String
      let correctAnswer: Bool
    }
    
    // вью модель для состояния "Вопрос показан"
    private struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    // вью модель для состояния "Результат квиза показан"
    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    // вью модель для состояния "Результат ошибки показан"
    private struct QuizErrorViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    // массив вопросов "mock-данные"
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
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
    
    // MARK: Обработка логики
        
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1) / 10")
    }
    
    // метод проверяет как ответил пользователь
    private func checkResultAnswer(isCorrect: Bool) -> Bool {
        if isCorrect == questions[currentQuestionIndex].correctAnswer {
            correctAnswers += 1
            return true
        }
        return false
    }
    
    // метод отвечающий за старт нового раунда квиза
    private func startNewRound() {
        currentQuestionIndex = 0
        correctAnswers = 0
        setAnswerButtonsEnabled(true)
        show(quiz: convert(model: self.questions[currentQuestionIndex]))
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            // Если это последний вопрос, показываем результаты
            show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!", text: "Ваш результат \(correctAnswers) / 10", buttonText: "Сыграть еще раз"))
        } else {
            // Плавный переход к следующему вопросу + анимация
            UIView.transition(with: self.view, duration: 2.0, options: .transitionCurlUp, animations: {
                self.currentQuestionIndex += 1
                self.setAnswerButtonsEnabled(true) // Включаем кнопки перед показом нового вопроса
                self.show(quiz: self.convert(model: self.questions[self.currentQuestionIndex]))
            }, completion: nil)
        }
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    // приватный метод для показа результатов раунда квиза
    private func show(quiz result: QuizResultsViewModel) {
        showAlert(title: result.title, message: result.text, textButton: result.buttonText)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }

    // метод для показа алерта
    private func showAlert(title p1: String, message p2: String, textButton p3: String) {
        let alert = UIAlertController(title: p1,
                                      message: p2,
                                      preferredStyle: .alert)

        let action = UIAlertAction(title: p3, style: .default) { _ in
            self.startNewRound()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // приватный метод отключения/включения кнопок
    private func setAnswerButtonsEnabled(_ enabled: Bool) {
        noButton.isEnabled = enabled
        yesButton.isEnabled = enabled
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        setAnswerButtonsEnabled(false)
        showAnswerResult(isCorrect: checkResultAnswer(isCorrect: false))
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        setAnswerButtonsEnabled(false)
        showAnswerResult(isCorrect: checkResultAnswer(isCorrect: true))
    }
}
