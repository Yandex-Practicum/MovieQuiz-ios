import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
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
    
    // переменная с индексом текущего вопроса, начальное значение 0
    // (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
    private var currentQuestionIndex = 0
    // переменная со счётчиком правильных ответов, начальное значение закономерно 0
    private var correctAnswers = 0
    // запускаем задачу через 1 секунду c помощью диспетчера задач
    
    // MARK: Входные параметры
    
    // структура самого вопроса
    private struct QuizQuestion {
      // строка с названием фильма,
      // совпадает с названием картинки афиши фильма в Assets
      let image: String
      // строка с вопросом о рейтинге фильма
      let text: String
      // булевое значение (true, false), правильный ответ на вопрос
      let correctAnswer: Bool
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
        show(quiz: convert(model: self.questions[currentQuestionIndex]))
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            show(quiz: QuizResultsViewModel(title: "Этот раунд окночен!", text: "Ваш результат \(correctAnswers) / 10", buttonText: "Сыграть еще раз"))
        } else {
            currentQuestionIndex += 1
            show(quiz: convert(model: questions[currentQuestionIndex]))
            // идём в состояние "Вопрос показан"
        }
    }
    
    // MARK: Обработка визуализации
    
    // вью модель для состояния "Вопрос показан"
    private struct QuizStepViewModel {
        // картинка с афишей фильма с типом UIImage
        let image: UIImage
        // вопрос о рейтинге квиза
        let question: String
        // строка с порядковым номером этого вопроса (ex. "1/10")
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
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    // приватный метод для показа результатов раунда квиза
    // принимает вью модель QuizResultsViewModel и ничего не возвращает
    private func show(quiz result: QuizResultsViewModel) {
        showAlert(title: result.title, message: result.text, textButton: result.buttonText)
    }
    
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        // изменение свойств imageView
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           // код, который мы хотим вызвать через 1 секунду
           self.showNextQuestionOrResults()
        }
    }

    private func showAlert(title p1: String, message p2: String, textButton p3: String) {
        // создаём объекты всплывающего окна
        let alert = UIAlertController(title: p1, // заголовок всплывающего окна
                                      message: p2, // текст во всплывающем окне
                                      preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet

        // создаём для алерта кнопку с действием
        // в замыкании пишем, что должно происходить при нажатии на кнопку
        let action = UIAlertAction(title: p3, style: .default) { _ in
            self.startNewRound()
        }

        // добавляем в алерт кнопку
        alert.addAction(action)

        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: checkResultAnswer(isCorrect: false))
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: checkResultAnswer(isCorrect: true))
    }
}
