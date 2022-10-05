import UIKit

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.text != rhs.text { return false }
        if lhs.image != rhs.image { return false }
        if lhs.correctAnswer != rhs.correctAnswer { return false }
        return true
    }
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

final class MovieQuizViewController: UIViewController {

    private let questions: [QuizQuestion] = [QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
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
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    private var currentQuestionIndex: Int = 0
    private var roundCount = 0
    private var correctAnswers: Int = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {
        answerIs(answer: false)
    }
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        answerIs(answer: true)
    }
    
    private func answerIs(answer: Bool) {
        showAnswerResult(isCorrect: answer == questions[currentQuestionIndex].correctAnswer)
    }
    
    private func showNextQuestionOrResults() {
      if currentQuestionIndex == questions.count - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
        // показать результат квиза
          self.roundCount += 1
          show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!", text: "Ваш результат: \(correctAnswers) из 10\nКоличество сыгранных квизов: \(roundCount)", buttonText: "Сыграть еще раз"))
      } else {
        currentQuestionIndex += 1 // увеличиваем индекс текущего вопроса на 1; таким образом мы сможем получить следующий вопрос
        // показать следующий вопрос
          show(quiz: convert(model: questions[currentQuestionIndex]))
      }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        imageView.layer.borderColor = isCorrect ? UIColor.YPGreen.cgColor : UIColor.YPRed.cgColor // делаем рамку цветной
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
            self?.imageView.layer.borderColor = UIColor.clear.cgColor
        }
        if isCorrect { correctAnswers += 1 }
    }
            
    
    private func show(quiz step: QuizStepViewModel) {
      // здесь мы заполняем нашу картинку, текст и счётчик данными
        counterLabel.text = step.questionNumber
        questionLabel.text = step.question
        imageView.image = step.image
    }

    private func show(quiz result: QuizResultsViewModel) {
      // здесь мы показываем результат прохождения квиза
        // создаём объекты всплывающего окна
        let alert = UIAlertController(title: result.title, // заголовок всплывающего окна
                                      message: result.text, // текст во всплывающем окне
                                      preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet

        // создаём для него кнопки с действиями
        let repeatAction = UIAlertAction(title: result.buttonText, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
          // вот этот код с переключением индекса и показом первого вопроса надо будет написать тут
            self.correctAnswers = 0
            self.currentQuestionIndex = 0
            self.show(quiz: self.convert(model: self.questions[self.currentQuestionIndex]))
        })
        
        alert.addAction(repeatAction)
        
        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let index = questions.firstIndex(where: { $0 == model })
        let indexText = index == nil ? "?" : "\(index! + 1)"
        let questionNumberText = "\(indexText)/\(questions.count)"
        let converted = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: questionNumberText)
        return converted
      }

}
