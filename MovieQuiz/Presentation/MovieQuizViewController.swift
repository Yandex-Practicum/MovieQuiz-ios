import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    ///переменная с индексом текущего вопроса, начальное значение 0
    ///(по этому индексу будем искать вопрос в массиве, где индекс первого элемента = 0
    private var currentQuestionIndex = 0
    
    ///переменная со счетчиком правильных ответов, начальное значение закономерно =0
    private var correctAnswers = 0
    
    /// массив вопросов
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Это первая структура из массива, первая потому что индекс вначале равен 0
        let currentQuestion = questions[currentQuestionIndex]
        let stepViewModel = convert(model: currentQuestion)
        show(quiz: stepViewModel)
        imageView.layer.cornerRadius = 20
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        //достаём текущий вопрос:
        let currentQuestion = questions[currentQuestionIndex]
        //булевая переменная которая содержит ТРУ если ответ сошелся
        let isCorrectAnswer = currentQuestion.correctAnswer == false
        showAnswerResult(isCorrect: isCorrectAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        //достаём текущий вопрос
        let currentQuestion = questions[currentQuestionIndex]
        let isCorrectAnswer = currentQuestion.correctAnswer == true
        showAnswerResult(isCorrect: isCorrectAnswer)
    }
    
    /// метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image1 = UIImage(named: model.image) ??  UIImage()
        let questionNumber1 = "\(currentQuestionIndex + 1)/\(questions.count)"
        let viewModel = QuizStepViewModel(image: image1,
                                          question: model.text,
                                          questionNumber: questionNumber1)
        return viewModel
    }
    
    ///приватный метод вывода на экран вопроса,
    ///который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    /// метод красит рамку, в зависимости от ответа ДА/НЕТ
    /// isCorrect это параметр который указывает верный ответ или нет.  Если true, ответ ВЕРНЫЙ, если false - неверный
    ///
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        //красим рамку в зависимости от того, правильный ответ или нет
        imageView.layer.borderColor = isCorrect == true ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect == true {
            correctAnswers += 1
        }
        //запускаем задачу через 1 секунду с помощью диспетчера задач:
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // который мы хотим вызвать через 1 секунду
            self.showNextQuestionOrResult()
        }
    }
    
    ///приватный метод, который содержит логику перехода в один из сценариев
    ///метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResult() {
        imageView.layer.borderColor = UIColor.clear.cgColor
        if currentQuestionIndex == questions.count - 1 {
            //идём в состояние результат Квиза
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                 text: text,
                                                 buttonText: "Сыграть еще раз")
            show(quiz: viewModel)
        } else {
            //Переходим к следующему вопросу
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    private func showAlert() {
        //создаём объекты всплывающего окна
        let alert = UIAlertController(title: "Этот раунд окончен!", message: "This is an alert", preferredStyle: .alert)
        //создаём для алерта кнопку с действием
        //в замыкании пишем, что должно происходить при нажатии на кнопку
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            //выводим на экран все вопросы занаво, начиная с первого:
            self.currentQuestionIndex = 0
            //обнуляем счетчик с результатами квиза:
            self.correctAnswers = 0
            
            let currentQuestion = self.questions[self.currentQuestionIndex]
            let stepViewModel = self.convert(model: currentQuestion)
            self.show(quiz: stepViewModel)
        }
        alert.addAction (action)
        
        //показываем всплывающее окно
        self.present(alert, animated: true)
    }
    
    /// приватный метод для показа результатов раунда квиза
    /// принимает вью модель QuizResultsViewModel и ничего не возвращает
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
      
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.correctAnswers = 0
            self.currentQuestionIndex = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
                   let viewModel = self.convert(model: firstQuestion)
                   self.show(quiz: viewModel)
            
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

struct QuizQuestion {
    ///Строка с названием фильма,
    ///Совпадает с названием картинки афиши фильма в Assets
    let image: String
    ///строка с вопросом о рейтинге фильма
    let text: String
    ///Булевое значение (true,false), правильный ответ на вопрос
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    ///картинка с афишей фильма с типом UIImage
    let image : UIImage
    ///вопрос о рейтинге квиза
    let question: String
    ///строка с порядковым номером этого вопроса (ex. "1/10")
    let questionNumber: String
}
/// для состояния "Результат квиза"
struct QuizResultsViewModel {
  let title: String
  let text: String
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
