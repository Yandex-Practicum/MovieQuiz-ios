import UIKit

final class MovieQuizViewController: UIViewController {
    
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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

    var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    var gamesPlayed: Int = 0
    var record: Int = 0
    var avgPerformance: Float = 0.0
    var allTimeCorrectAnswers: Int = 0
    
    private func convertQuestion(model: QuizQuestion) -> QuizStepViewModel {
        
        return QuizStepViewModel(
                image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
                question: model.text, // берём текст вопроса
                questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // высчитываем номер вопроса
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.layer.borderWidth = 0
        
    }

    
    private func show(quiz result: QuizResultsViewModel) {
      // здесь мы показываем результат прохождения квиза
        
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)

        // создаём для него кнопки с действиями
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            // заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convertQuestion(model: firstQuestion)
            self.show(quiz: viewModel)
        }

        // добавляем в алерт кнопки
        alert.addAction(action)

        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func checkAnswer(answerGiven: Bool) -> Bool {
        var result: Bool = false
        let currentQuestion = questions[currentQuestionIndex]
        if answerGiven == currentQuestion.correctAnswer {
            result = true
        }
        return result
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        correctAnswers += isCorrect ? 1 : 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func generateResult() -> QuizResultsViewModel {
        
        allTimeCorrectAnswers += correctAnswers
        gamesPlayed += 1
        
        if correctAnswers > record {
            record = correctAnswers
        }
            
        avgPerformance = Float(allTimeCorrectAnswers / gamesPlayed * 10)
        
        return QuizResultsViewModel(title: "Этот раунд окончен!",
                                    text: "Ваш результат: \(correctAnswers)/10 \n Кол-во сыгранных квизов: \(gamesPlayed) \n Рекорд: \(record) \n средняя точность: \(avgPerformance)%",
                                    buttonText: "Сыграть еще раз")
    }
    
    
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questions.count - 1 {
            
            show(quiz: generateResult())

        } else {
            currentQuestionIndex += 1
            let currentQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convertQuestion(model: currentQuestion)
            show(quiz: viewModel)
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton!) {
        
        var result = checkAnswer(answerGiven: false)
        showAnswerResult(isCorrect: result)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton!) {
        var result = checkAnswer(answerGiven: true)
        showAnswerResult(isCorrect: result)
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
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
