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
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.ypWhite.cgColor
        imageView.layer.cornerRadius = 6
        
        showNextQuestionOrResults()
    }
    
    //actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: false)}
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: true)}
    
    //private methods
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionTextLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // приватный метод конвертации, который принимает моковый вопрос и возвращает вью модель для главного экрана
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),//Инициализирую картинку с помощью конструктора UIImage(named: )
            question: model.text, //забираем уже готовый вопрос из мокового вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") //Высчитываем номер вопроса с помощью переменной текущего вопроса currentQuestionIndex
        return questionStep
    }
    
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count  {
            // идём в состояние "Результат квиза"
            showQuizResultsAlert(buttonTitle: "Сыграть ещё раз")
        } else {
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
//            correctAnswers = 0 // Здесь обнуляем correctAnswers перед переходом на новый раунд
        }
    }
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        let currentQuestion = questions[currentQuestionIndex]
        let isCorrect = isCorrect == currentQuestion.correctAnswer
        
        if isCorrect {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        currentQuestionIndex += 1
        //        showNextQuestionOrResults()
        print("кол-во правильных ответов \(correctAnswers)") //понимаю что логика работает
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in //добавил задержку
            self?.imageView.layer.borderColor = UIColor.white.cgColor // Сброс цвета рамки перед отображением следующего вопроса
            self?.showNextQuestionOrResults()
        }
    }
    
    private func showQuizResultsAlert(buttonTitle: String) {
        let currentDate = Date() // текущая дата и время
        let dateFormatter = DateFormatter() // форматтер для преобразования даты в строку
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let formattedDate = dateFormatter.string(from: currentDate) // преобразуем текущую дату в строку
        
        var averagePercentage: Int //средний процент правильных ответов
        if questions.count > 0 {
            averagePercentage = correctAnswers * 100 / questions.count
        } else {
            averagePercentage = 0
        }
        
        let alert = UIAlertController(
            title: "Этот раунд окончен!",
            message: "Ваш результат: \(correctAnswers) из \(questions.count)\nТочность: \(averagePercentage)% \nВремя: \(formattedDate)",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0 // Здесь обнуляем correctAnswers перед переходом на новый раунд
            
            let firstQuestion = self.questions[self.currentQuestionIndex] // заново показываем первый вопрос
            let viewModel = self.convert(model: firstQuestion) // заново показываем первый вопрос
            self.show(quiz: viewModel) // заново показываем первый вопрос
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

struct QuizQuestion { //преобразование данных из структуры вопроса QuizQuestion во вью модель для экрана QuizStepViewModel.
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

