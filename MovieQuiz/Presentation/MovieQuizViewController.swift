import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    private struct QuizStepViewModel {
        var image: UIImage
        let question: String
        let questionNumber: String
    }

    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }

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
            correctAnswer: false)]

    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
        
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
      // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    private func show(quiz result: QuizResultsViewModel) {
      // здесь мы показываем результат прохождения квиза
        //создаем объект всплывающего окна
        let alert = UIAlertController(title: result.title, // заголовок всплывающего окна
                                      message: result.text, // текст во всплывающем окне
                                      preferredStyle: .alert) // может быть actionSheet либо alert
        // создаем кнопки с действиями
        let action = UIAlertAction(title: result.buttonText, style: .default, handler: { _ in self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        })
        
        //добавляем в алерт кнопки
        alert.addAction(action)
        
        //показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true // даем разрешение на создание рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // выбор цвето в зависимости от правильности ответа
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
      if currentQuestionIndex == questions.count - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
        // показать результат квиза
          imageView.layer.borderColor = UIColor.clear.cgColor
          let text = "Ваш результат: \(correctAnswers) из 10"
          let viewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: text,
            buttonText: "Сыграть еще раз")
          show(quiz: viewModel)
      } else {
          imageView.layer.borderColor = UIColor.clear.cgColor
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
        let viewModel = convert(model: currentQuestion)
        show(quiz: viewModel)
    }
 
/*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        Тут имеет смысл дополнительно настроить наши изображения, например,
        задать цвет фона для экрана.
        */
      }
 */
    
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
