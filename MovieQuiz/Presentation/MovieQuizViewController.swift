import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    // Аутлеты кнопок для задержки нажатия (до момента появления нового вопроса):
    @IBOutlet var noButton: UIButton!
    @IBOutlet var yesButton: UIButton!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        toggleButtons() // Блокировка кнопки
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnsver = true
        showAnswerResult(isCorrect: givenAnsver == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        toggleButtons() // Блокировка кнопки
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnsver = false
        showAnswerResult(isCorrect: givenAnsver == currentQuestion.correctAnswer)
    }
    
    private var currentQuestionIndex: Int = 0 // Переменная отвечающая за индекс текущего вопроса
    private var correctAnswers: Int = 0 // Переменная отвечающая за количество правильных ответов
    
    // Описание состояний экрана: для состояния "Вопрос задан"
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    // Описание состояний экрана: для состояния "Результат квиза"
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    // Реализация логики приложения (структура):
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion( // 1
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion( // 2
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion( // 3
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion( // 4
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion( // 5
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion( // 6
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion( // 7
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion( // 8
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion( // 9
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion( // 10
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Загрузка первого вопроса при старте приложения:
        let firstQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: firstQuestion))
        
    }

     override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
     /*
      Тут имеет смысл дополнительно настроить наши изображения, например,
      задать цвет фона для экрана.
      */
     }

     override func viewDidAppear(_ animated: Bool) {
     super.viewDidAppear(animated)
     /*
      Тут имеет смысл оповестить систему аналитики о том, что экран показался.
      */
     }

     override func viewWillDisappear(_ animated: Bool) {
     super.viewWillDisappear(animated)
     /*
      Тут имеет смысл остановить все процессы, которые происходили на этом экране.
      */
     }

     override func viewDidDisappear(_ animated: Bool) {
     super.viewDidDisappear(animated)
     /*
      Тут имеет смысл оповестить систему аналитики, что экран перестал показываться
      и привести его в изначальное состояние.
      */
     }

    // Функция отображения вопроса на экране:
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    // Функция конвертации из QuizQuestion в QuizStepViewModel:
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    // Функция отображения результата
    private func show(quiz result: QuizResultsViewModel) {
        // здесь мы показываем результат прохождения квиза
        // создаем объекты всплывающего окна:
        let alert = UIAlertController(
            title: result.title, // заголовок
            message: result.text, // текст в всплывающем окне
            preferredStyle: .alert) // Стиль alert

        // создаём для него кнопки с действиями:
        let action = UIAlertAction(title: result.buttonText, style: .default) {_ in
            self.currentQuestionIndex = 0
            
            // скидываем счетчик правильных ответов:
            self.correctAnswers = 0
            
            // Заново показываем первый вопрос:
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        // добавляем в алерт кнопки:
        alert.addAction(action)

        // показываем всплывающее окно:
        self.present(alert, animated: true, completion: nil)
    }
    
    // Функция проверки правильности ответа с отображением рамки (зеленая / красная)
    private func showAnswerResult(isCorrect: Bool) {
        // увеличение счетчика на 1 если ответ правильный:
        if isCorrect {
            correctAnswers += 1
        }
        // рамка картинки в зависимости от правильности ответа:
        imageView.layer.masksToBounds = true // разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // цвета рамки

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {// запуск слудеющего вопроса с задержкой в 1 секунду через дипетчер
            self.imageView.layer.borderColor = UIColor.clear.cgColor // Прозрачная рамка до ответа
            self.showNextQuestionOrResults()
            self.toggleButtons() // Разблокировка кнопок через 1 сек
        }
    }
    
    // Функция отображения результата квиза
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
            // показать результат квиза
            let text = "Ваш результат: \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1 // увеличиваем индекс текущего вопроса на 1; таким образом мы сможем получить следующий вопрос
            // показать следующий вопрос
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    // Функция включения / выключения кнопок для задержки нажатия:
    private func toggleButtons () {
        noButton.isEnabled.toggle()
        yesButton.isEnabled.toggle()
    }
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
