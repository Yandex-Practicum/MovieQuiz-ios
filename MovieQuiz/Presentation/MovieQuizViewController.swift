import UIKit

final class MovieQuizViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var currentQuestion: QuizQuestion {
        questions[currentQuestionIndex]
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
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //let currentQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: currentQuestion)
        show(quiz: viewModel)
        
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        print(sender.frame)
        let givenAnswer = true
        //let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        print(currentQuestion)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let givenAnswer = false
        //let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
            imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
            imageView.layer.borderWidth = 8 // толщина рамки
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // делаем рамку зеленой или красной
            togglenteraction() //отключаем кнопки и затемняем
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.togglenteraction() //включаем кнопки и ставим альфу 1
                self.showNextQuestionOrResults()
                self.imageView.layer.borderWidth = 0
                
            }
        
        }
   private func togglenteraction() {
        self.noButton.isEnabled.toggle() //отключаем кнопки чтобы нельзя было выбирать во время задержки
        self.yesButton.isEnabled.toggle()
        self.yesButton.alpha = yesButton.isEnabled ? 1.0 : 0.8
        self.noButton.alpha = noButton.isEnabled ? 1.0 : 0.8
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        
    }
    private func show(quiz result: QuizResultsViewModel) {
        // создаём объекты всплывающего окна
        
        let alert = UIAlertController(title: result.title, // заголовок всплывающего окна
                                      message: result.text, // текст во всплывающем окне
                                      preferredStyle: .alert) 

        // создаём для него кнопки с действиями
        let action = UIAlertAction(title: result.buttonText, style: .default, handler: { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            //заново показываем первый вопрос
            let viewModel = self.convert(model: self.currentQuestion)
            self.show(quiz: viewModel)
            
        })

        // добавляем в алерт кнопки
        alert.addAction(action)

        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func showNextQuestionOrResults() {
            if self.currentQuestionIndex == self.questions.count - 1 {
                let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                  text: "Ваш результат \(correctAnswers)/\(questions.count)",
                                                  buttonText: "Сыграть еще раз")
                show(quiz: viewModel)
            } else {
                self.currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1
                let nextQuestion = questions[currentQuestionIndex]
                let viewModel = convert(model: nextQuestion)
                
                show(quiz: viewModel)
            }
        }
        
        
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(named: model.image) ?? UIImage()
        let question = model.text
        let questionNumber = "\(currentQuestionIndex + 1)/\(questions.count)"
        //currentQuestionIndex += 1
        return QuizStepViewModel(image: image, question: question, questionNumber: questionNumber)
      }
    
    
}
 // Состояние вопрос задан
fileprivate struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}
//состояние результат квиза
fileprivate struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}

//модель вопроса
fileprivate struct QuizQuestion {
  let image: String
  let text: String
  let correctAnswer: Bool
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
