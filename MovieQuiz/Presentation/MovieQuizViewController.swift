import UIKit

// Исходные данные

struct QuizQuestion {
  let image: String
  let text: String
  let correctAnswer: Bool
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
    
    // Обнуление счетчика текущуего вопроса
    
    private var currentQuestionIndex: Int = 0
    
    // Обнуление счетчика правильных ответов
    
    private var correctanswerQuestion = 0
    
    private var currentQuestion: QuizQuestion { questions[currentQuestionIndex]
    }
    
    // Функция кнопки НЕТ
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        let currentQuestion = questions[currentQuestionIndex]
        let givenanswer = false
        showAnswerResult(isCorrect: givenanswer == currentQuestion.correctAnswer)
    }
    
    // Функция кнопки ДА
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        let currentQuestion = questions[currentQuestionIndex]
        let givenanswer = true
        showAnswerResult(isCorrect: givenanswer == currentQuestion.correctAnswer)
    }
    
    // Картинка
    
    @IBOutlet private var imageView: UIImageView!
    
    // Текст вопрса
    
    @IBOutlet private var textLabel: UILabel!
    
    // Счетчик текущего вопроса
    
    @IBOutlet private var counterLabel: UILabel!
    
        // Функция конвертирования из исходных данных в состояние "Показ вопроса"
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // высчитываем номер вопроса
    }
    
        // Функция счетчика правильных ответов, цветовой рамки взависимости от правильного ответа, показа следующиего вороса
    
    private func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect {
            correctanswerQuestion+=1
        }
        
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = isCorrect ? UIColor(named: "YP Green")?.cgColor : UIColor(named: "YP Red")?.cgColor
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        
        
        // Задержка на 1 сек. показа след. вопроса квиза
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            // Очистка цвета рамки
            
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            
                self.showNextQuestionOrResults()
            }

    }
    
    
    // Функция показа текущей картинки, текста вопроса, счетчика вопроса
    
    private func show(quiz step: QuizStepViewModel) {
            imageView.image = step.image
            counterLabel.text = step.questionNumber
            textLabel.text = step.question
        }
    
    // Функция показа резульата квиза или следующего вопроса
    
    private func showNextQuestionOrResults(){
           if currentQuestionIndex == questions.count - 1{
               let text = "Ваш результат: \(correctanswerQuestion) из 10"
               let viewModel = QuizResultsViewModel(title: "Этот раунд окончен",
                                                    text: text,
                                                    buttonText: "Сыграть еще раз")
             
               // Здесь функция show -- c данными из QuizResultsViewModel
               
               show(quiz: viewModel)
               
           } else {
               currentQuestionIndex += 1
               let nextQuestion = questions[currentQuestionIndex]
               let viewModel = convert(model: nextQuestion)
               
                // Здесь функция show -- c данными из QuizStepViewModel
               
              
               
               show(quiz: viewModel)
           }
       }
        
    // Функция алерта результата квиза
    
    private func show(quiz result: QuizResultsViewModel) {
               let alert = UIAlertController(title: result.title,
                                         message: result.text,
                                         preferredStyle: .alert)
           let action = UIAlertAction(title: result.buttonText, style: .default) {_ in
               self.currentQuestionIndex = 0
               self.correctanswerQuestion = 0
               
               // Переход на первый вопрос
               
               let firstQuestion = self.questions[self.currentQuestionIndex]
               let viewModel = self.convert(model: firstQuestion)
               self.show(quiz: viewModel)
           }
           alert.addAction(action)
           self.present(alert, animated: true, completion: nil)
   }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let viemodel = convert(model: questions[currentQuestionIndex])
        
        show(quiz: viemodel)
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
