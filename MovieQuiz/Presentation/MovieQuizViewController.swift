import UIKit

final class MovieQuizViewController:
    UIViewController {
    
    // Функции кнопок
    // Нет
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    // Да
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    
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

    struct QuizQuestion {
      let image: String
      let text: String
      let correctAnswer: Bool
    }
    
    static let quizQuestion: String = "Рейтинг этого фильма больше чем 6?"
    
    private let questions: [QuizQuestion] = [
            QuizQuestion(
                image: "The Godfather",
                text: quizQuestion,
                correctAnswer: true),
            QuizQuestion(
                image: "The Dark Knight",
                text: quizQuestion,
                correctAnswer: true),
            QuizQuestion(
                image: "Kill Bill",
                text: quizQuestion,
                correctAnswer: true),
            QuizQuestion(
                image: "The Avengers",
                text: quizQuestion,
                correctAnswer: true),
            QuizQuestion(
                image: "Deadpool",
                text: quizQuestion,
                correctAnswer: true),
            QuizQuestion(
                image: "The Green Knight",
                text: quizQuestion,
                correctAnswer: true),
            QuizQuestion(
                image: "Old",
                text: quizQuestion,
                correctAnswer: false),
            QuizQuestion(
                image: "The Ice Age Adventures of Buck Wild",
                text: quizQuestion,
                correctAnswer: false),
            QuizQuestion(
                image: "Tesla",
                text: quizQuestion,
                correctAnswer: false),
            QuizQuestion(
                image: "Vivarium",
                text: quizQuestion,
                correctAnswer: false)
        ]

    private func show(quiz step: QuizStepViewModel) {
      // здесь мы заполняем нашу картинку, текст и счётчик данными
      counterLabel.text = step.questionNumber
      imageView.image = step.image
      textLabel.text = step.question
    }

    // здесь мы показываем результат прохождения квиза:
    private func show(quiz result: QuizResultsViewModel) {
        
        // создаём объекты всплывающего окна:
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        // создаём для него кнопки с действиями
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            
            // скидываем счётчик правильных ответов
            self.correctAnswers = 0
            
            
            // заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        // добавляем в алерт кнопки
        alert.addAction(action)
        
        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var answer: Bool = true
    private lazy var currentQuestion = questions[currentQuestionIndex]

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // высчитываем номер вопроса
    }

    //Создаем рамку картинки красной или зеленой в зависимости от ответа
    private func showAnswerResult(isCorrect: Bool) {
        // Счетчик правильных ответов
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true // отрисовка рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // Скругление углов
        imageView.layer.borderColor = isCorrect ? UIColor(named: "YP Green")?.cgColor : UIColor(named: "YP Red")?.cgColor //проверка правильности ответа
        
        //запуск задачи через 1 секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
      if currentQuestionIndex == questions.count - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
        // показать результат квиза
        let text = "Ваш результат: \(correctAnswers) из \(questions.count)"
          _ = "Количество сыгранных квизов: "
        let viewModel = QuizResultsViewModel(
                   title: "Этот раунд окончен!",
                   text: text,
                   buttonText: "Сыграть ещё раз")
               show(quiz: viewModel)
        
      } else {
    
        currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
        // показать следующий вопрос
        let nextQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: nextQuestion)
        show(quiz: viewModel)
        
      }
    }

      override func viewDidLoad() {
          super.viewDidLoad()
          let currentQuestion = questions[currentQuestionIndex]
          show(quiz: convert(model: currentQuestion))
          self.imageView.layer.cornerRadius = 20
      }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
  }
