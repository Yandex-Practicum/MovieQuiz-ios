import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet weak var TItleQuestionLabel: UILabel!
    @IBOutlet weak var IndexQuestionLabel: UILabel!
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var NoButton: UIButton!
    @IBOutlet weak var YesButton: UIButton!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
            let givenAnswer = false
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        YesButton.isEnabled = false
        NoButton.isEnabled = false
    }
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        YesButton.isEnabled = false
        NoButton.isEnabled = false
    }
    
    // MARK: - Lifecycle
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        TItleQuestionLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        IndexQuestionLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        QuestionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        NoButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        YesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
    
    let currentQuestion = questions[currentQuestionIndex]
    let currentQuestionViewModel = convert(model: currentQuestion)
    show(quiz: currentQuestionViewModel)
       
    }


struct QuizQuestion {
  let image: String
  let text: String
  let correctAnswer: Bool
}

struct ViewModel {
  let image: UIImage
  let question: String
  let questionNumber: String
}

// для состояния "Вопрос задан"
struct QuizStepViewModel {
  let image: UIImage
  let question: String
  let questionNumber: String
}

// для состояния "Результат квиза"
struct QuizResultsViewModel {
  let title: String
  let text: String
  let buttonText: String
}

private func convert(model: QuizQuestion) -> QuizStepViewModel {
    return QuizStepViewModel(
        image: UIImage(named: model.image) ?? UIImage(),
        question: model.text,
        questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
)
}


   
private func show(quiz step: QuizStepViewModel) {
    textLabel.text = step.question
    imageView.image = step.image
    counterLabel.text = step.questionNumber
   
}

private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
    if isCorrect == true {
        imageView.layer.borderColor = UIColor.ypGreen.cgColor
        correctAnswers += 1}
    else {imageView.layer.borderColor =
        UIColor.ypRed.cgColor}
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // запускаем задачу через 1 секунду
        self.imageView.layer.borderColor = UIColor.clear.cgColor
        self.showNextQuestionOrResults()
    }
}
    
private func showNextQuestionOrResults() {
  if currentQuestionIndex == questions.count - 1 { // -
       let text = "Ваш результат: \(correctAnswers)/\(10)"
       let resultViewModel = QuizResultsViewModel(
          title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
      show(quiz: resultViewModel)
      YesButton.isEnabled = true
      NoButton.isEnabled = true
      } else {
        currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
          let nextQuestion = questions[currentQuestionIndex]
          let nextQuestionViewModel = convert(model: nextQuestion)
          show(quiz: nextQuestionViewModel)
          YesButton.isEnabled = true
          NoButton.isEnabled = true
      }
}
    
private func show(quiz result: QuizResultsViewModel) {
    // создаём объекты всплывающего окна
    let alert = UIAlertController(title: result.title, // заголовок всплывающего окна
                                  message: result.text, // текст во всплывающем окне
                                  preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet

    // создаём для него кнопки с действиями
    let action = UIAlertAction(title: "Сыграть еще раз", style: .default) { _ in
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        
    let firstQuestion = self.questions[self.currentQuestionIndex]
    let viewModel = self.convert(model: firstQuestion)
    self.show(quiz: viewModel)
    }

    // добавляем в алерт кнопки
    alert.addAction(action)

    // показываем всплывающее окно
    self.present(alert, animated: true, completion: nil)
}

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
