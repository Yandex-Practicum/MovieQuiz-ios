import UIKit

// Структура для состояния "Вопрос задан"
private struct QuizStepViewModel {
    var image: UIImage
    var question: String
    var questionNumber: String
}

// Структура для состояния "Результат квиза"
private struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}

// Структура для описания Mock-данных
fileprivate struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

final class MovieQuizViewController: UIViewController {
    //MARK: - Properties
    // Аутлеты для текста, счётчика, изображения и кнопок
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    // Переменная индекса текущего вопроса в MovieQuizViewController
    private var currentQuestionIndex: Int = 0
    // Переменная для подсчёта колличества верных ответов
    private var correctAnswers: Int = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        startGame(question: questions)
    }
    //MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        correctAnswerIs() == false ? showAnswerResult(isCorrect: true) : showAnswerResult(isCorrect: false)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        correctAnswerIs() == true ? showAnswerResult(isCorrect: true) : showAnswerResult(isCorrect: false)
    }
    //MARK: - Helpers
    //Функция проверки правильности ответа, данного пользователем
    private func correctAnswerIs() -> Bool{
        return self.questions[currentQuestionIndex].correctAnswer
    }
    
    //Функция блокировки переключения активности кнопок. Используется в showAnswerResult
    private func toggleIsEnablebButtons(){
        noButton.isEnabled.toggle()
        yesButton.isEnabled.toggle()
    }
    
    // Функция для создания первой вью модели
    private func startGame(question: [QuizQuestion]?){
        guard let questions = question else{
            return
        }
        let viewModel = convert(model: questions[0])
        show(quiz: viewModel)
        print(viewModel.questionNumber)
    }
    
    // функция для передачи в вью модель необходимых данных
    private func show(quiz step: QuizStepViewModel) {
        self.imageView.image = step.image
        self.textLabel.text = step.question
        self.counterLabel.text = step.questionNumber
    }
    
    //Функция для вызова алерта с результатами раунда
    private func show(quiz result: QuizResultsViewModel) {
        //передача в алерт данных из QuizResultsViewModel
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        // создание экшна кнопки
        let action = UIAlertAction(
            title: result.buttonText,
            style: .default
        ) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            // заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Функция преобразования вопроса в вью модель
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: String("\(currentQuestionIndex + 1)/\(questions.count)")
        )
    }
    
    //Функция для отображения рамки с цветовой индикацией правильности ответа и блокировки кнопок на времяпоказа рамки с последующей разблокировкой и убиранием рамки
    private func showAnswerResult(isCorrect: Bool){
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            self.toggleIsEnablebButtons()
            //self.imageView.layer.borderColor = self.view.layer.backgroundColor
        }
        toggleIsEnablebButtons()
    }
    
    //функция выбора действия: показ результата раунда, если вопрос последний или следующего вопроса
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers) из \(questions.count)"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен",
                text: text,
                buttonText: "Сыграть ещё раз")
            self.show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            self.show(quiz: viewModel)
        }
    }
}
//MARK: - Extension
//Расширение класса MovieQuizViewController, в который убран массив Mock данных
private extension MovieQuizViewController {
    // Vассив стуктур Mock данных
    var questions: [QuizQuestion] {
        [ QuizQuestion(
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
            correctAnswer: false)]
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
