import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.font = UIFont(name:"YS Display-Bold",size:17)
        textLabel.font = UIFont(name:"YS Display-Medium",size:17)
        label.font = UIFont(name:"YS Display-Medium",size:17)
        var quiz1: QuizStepViewModel = convert(model: questions[currentQuestionIndex])
        show(quiz: quiz1)
    }
    
    
    // функция выводящая каритинку и вопрос на экран
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    private var allAmountOfCorrectAnswers: Int = 0
    private var resultText: String = ""
    
    //Функция показывающая результат ответ (верно - зеленый, не верно - красный)
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        if isCorrect {
            allAmountOfCorrectAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else
        {
            imageView.layer.borderColor = UIColor.ypRed.cgColor}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
        }
    }
    
    /*private func show(quiz result: QuizResultsViewModel) {
        // здесь мы показываем результат прохождения квиза
    }*/
    
    private func showNextQuestionOrResults() {
      if currentQuestionIndex == questions.count - 1 {
          //if allAmountOfCorrectAnswers > 5 {
              resultText = "Ваш результат: \(allAmountOfCorrectAnswers)/\(questions.count)\n" + "Подздравляем! Больше половины правильных ответов!"
          //} else {resultText = "You loose"}
          
          // создаём объекты всплывающего окна
          let alert = UIAlertController(title: "Этот раунд окончен!", // заголовок всплывающего окна
                                        message: resultText, // текст во всплывающем окне
                                        preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet

          // создаём для него кнопки с действиями
          let action = UIAlertAction(title: "Сыграть еще раз", style: .default) { _ in
              self.allAmountOfCorrectAnswers = 0
              currentQuestionIndex = 0
              var quiz3: QuizStepViewModel = convert(model: questions[currentQuestionIndex])
              self.show(quiz: quiz3)
          }

          // добавляем в алерт кнопки
          alert.addAction(action)

          // показываем всплывающее окно
          self.present(alert, animated: true, completion: nil)
      } else {
          currentQuestionIndex += 1
          var quiz2: QuizStepViewModel = convert(model: questions[currentQuestionIndex])
          show(quiz: quiz2)
          // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
        // показать следующий вопрос
      }
    }
    
    
    
    
    private var isCorrect1: Bool = true
    
    //Нажатие на кнопку "да"
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        if questions[currentQuestionIndex].correctAnswer == true {isCorrect1 = true} else {isCorrect1 = false}
        showAnswerResult(isCorrect: isCorrect1)
    }
    
    //Нажатие на кнопку "нет"
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        if questions[currentQuestionIndex].correctAnswer == false {isCorrect1 = true} else {isCorrect1 = false}
        showAnswerResult(isCorrect: isCorrect1)
    }
    
    @IBOutlet private var label: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    
}



// для состояния "Вопрос задан"
private struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

// для состояния "Результат квиза"
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
            correctAnswer: false)
    ]
    
    

    
    
    
    private var currentQuestionIndex: Int = 0
    private let currentQuestion = questions[currentQuestionIndex]
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        // Попробуйте написать код конвертации сами
        
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
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
