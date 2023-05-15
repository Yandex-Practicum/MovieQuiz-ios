import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    /*
     Привет код-ревьюерам!
     -------------------------------------------------------------------------------------------------------------------------------
     ____🐸🐸🐸🐸____🐸🐸🐸
     ___🐸🐸🐸🐸🐸__🐸🐸🐸🐸
     __🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸
     🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸
     🐸🐸⚪️⚫️⚫️⚪️🐸🐸🐸⚪️⚫️⚫️⚪️
     🐸⚪️⚫️⚫️⚪️⚫️⚪️🐸⚪️⚫️⚫️⚪️⚫️⚪️
     🐸⚪️⚫️⚪️⚫️⚫️⚪️🐸⚪️⚫️⚪️⚫️⚫️⚪️
     🐸🐸⚪️⚫️⚪️⚪️🐸🐸🐸⚪️⚫️⚪️⚪️
     🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸
     🔴🔴🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸
     🐸🔴🔴🐸🐸🐸🐸🐸🐸🐸🐸🐸
     🐸🐸🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴
     🐸🐸🐸🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴
     🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸
     🐸🐸🐸🐸🐸🐸🐸🐸🐸🐸
     🐸🐸🐸🐸🐸🐸🐸🐸🐸
     -------------------------------------------------------------------------------------------------------
     */
    
    
    
    
    
    
    @IBOutlet private var imageView: UIImageView! //imageView outlet
    @IBOutlet private var textLabel: UILabel!     //textLabel outlet
    @IBOutlet private var counterLabel: UILabel!  //counterLabel otlet
    
    
    // вью модель для состояния "Вопрос показан"
   private struct QuizStepViewModel {
      // картинка с афишей фильма с типом UIImage
      let image: UIImage
      // вопрос о рейтинге квиза
      let question: String
      // строка с порядковым номером этого вопроса (ex. "1/10")
      let questionNumber: String
    }
    
    //структура для вопросов
   private struct QuizQuestion {
      // строка с названием фильма,
      // совпадает с названием картинки афиши фильма в Assets
      let image: String
      // строка с вопросом о рейтинге фильма
      let text: String
      // булевое значение (true, false), правильный ответ на вопрос
      let correctAnswer: Bool
    }

    // для состояния "Результат квиза"
   private struct QuizResultsViewModel {
      // строка с заголовком алерта
      let title: String
      // строка с текстом о количестве набранных очков
      let text: String
      // текст для кнопки алерта
      let buttonText: String
    }
    
    
    // переменная с индексом текущего вопроса, начальное значение 0
    private var currentQuestionIndex = 0
    
    // переменная со счётчиком правильных ответов, начальное значение 0
    private var correctAnswers = 0
    
    
    //no button private func
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
            let answer = false
            showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }

    
    //yes button private func
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
            let answer = true
            showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
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
    
    
    // приватный метод, который и меняет цвет рамки, и вызывает метод перехода
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
                correctAnswers += 1
            }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        self.showNextQuestionOrResults()
        }
    }
    
    // приватный метод конвертации, который принимает моковый вопрос и возвращает вью модель для главного экрана
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionToView = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionToView
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.cornerRadius = 20
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    private func showNextQuestionOrResults() {
        imageView.layer.borderColor = UIColor.clear.cgColor // setting imageView's border to clear
        
        if currentQuestionIndex == questions.count - 1 {
            // идём в состояние "Результат квиза"
                    let text = "Ваш результат: \(correctAnswers)/10"
                    let viewModel = QuizResultsViewModel(
                        title: "Этот раунд окончен!",
                        text: text,
                        buttonText: "Сыграть ещё раз")
                    showResults(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        }
    }
    
    // приватный метод для показа результатов раунда квиза
    // принимает вью модель QuizResultsViewModel и ничего не возвращает
    private func showResults(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        // берём текущий вопрос из массива вопросов по индексу текущего вопроса
        // и вызываем метод show() для первого вопроса
        let currentQuestion = questions[currentQuestionIndex]
        let firstQuestion = convert(model: currentQuestion)
        show(quiz: firstQuestion)
        super.viewDidLoad()
    }
}



//    По индексу текущего вопроса находим в массиве нужный нам моковый вопрос;
//    Создаём константу, которая в зависимости от метода имеет значение «правда» или «ложь» соответственно;
//    Передаём в метод покраски рамок значение, сравнивая правильный ответ и ответ, который дал пользователь.
