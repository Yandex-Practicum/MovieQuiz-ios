import UIKit

final class MovieQuizViewController: UIViewController {

  @IBOutlet private var imageView: UIImageView! // добавлено изображение
  @IBOutlet private var textLabel: UILabel! // добавлен лейбл с вопросом
  @IBOutlet private var counterLabel: UILabel! // добавлен лейбл каунтер

  private var currentQuestionIndex = 0 // начально значение текущего вопроса 0
  private var correctAnswers = 0 // начально значение каунтера текущего ответа 0

  private let questions: [QuizQuestion] = [ // моки для квиза
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
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    show(quiz: convert(model:questions[0]))
  }

  private func convert(model: QuizQuestion) -> QuizStepViewModel {  // добавлен метод конвертации
    let questionStep = QuizStepViewModel (
      image: UIImage(named: model.image) ?? UIImage(),
      question: model.text,
      questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    return questionStep
  }

  private func show(quiz step: QuizStepViewModel) { // добавлен метод вывода на экран вопроса
    counterLabel.text = step.questionNumber
    imageView.image = step.image
    textLabel.text = step.question
  }

  private func showAnswerResult(isCorrect: Bool) { // добавлен метод обработки ответа и подсвечивания рамки
    if isCorrect { // 1
      correctAnswers += 1 // 2
    }
    imageView.layer.masksToBounds = true
    imageView.layer.borderWidth = 8
    imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
      self?.showNextQuestionOrResults()
      self?.imageView.layer.borderColor = UIColor.clear.cgColor
    }
  }
  private func showNextQuestionOrResults() {  // добавлен метод перехода к следующему вопросу или завершения квиза
    if currentQuestionIndex == questions.count - 1 { // 1
      let text = "Ваш результат: \(correctAnswers)/10"
      let viewModel = QuizResultsViewModel (
        title: "Этот раунд окончен!",
        text: text,
        buttonText: "Сыграть ещё раз")
      show(quiz: viewModel)
    } else {
      currentQuestionIndex += 1
      let nextQuestion = questions[currentQuestionIndex]
      let viewModel = convert(model: nextQuestion)

      show(quiz: viewModel)
    }
  }
  private func show(quiz result: QuizResultsViewModel) { // метод показывающий результаты квиза
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

  @IBAction private func noButtonClicked(_ sender: UIButton) { // добавлем логику на нажатие "Нет"
    let currentQuestion = questions[currentQuestionIndex]
    let giveAnswer = false

    showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
  }

  @IBAction private func yesButtonClicked(_ sender: UIButton) { // добавлем логику на нажатие "Да"
    let currentQuestion = questions[currentQuestionIndex]
    let giveAnswer = true

    showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
  }
}
struct QuizQuestion { // структура для вопроса
  // строка с названием фильма,
  // совпадает с названием картинки афиши фильма в Assets
  let image: String
  // строка с вопросом о рейтинге фильма
  let text: String
  // булевое значение (true, false), правильный ответ на вопрос
  let correctAnswer: Bool
} 
struct QuizStepViewModel {  // структура для показа вопроса
  // картинка с афишей фильма с типом UIImage
  let image: UIImage
  // вопрос о рейтинге квиза
  let question: String
  // строка с порядковым номером этого вопроса (ex. "1/10")
  let questionNumber: String
}
struct QuizResultsViewModel {  // структура для показа результата
  // строка с заголовком алерта
  let title: String
  // строка с текстом о количестве набранных очков
  let text: String
  // текст для кнопки алерта
  let buttonText: String
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
