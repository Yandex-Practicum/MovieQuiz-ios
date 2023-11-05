import UIKit

//Структура вопроса квиза
struct QuizQuestion {
    //Строка с названием фильма
    //Совпадает с названием картинки афиши фильма в Assets
    var image: String
    
    //Строка с названием вопроса о фильме
    var text: String
    
    //Будевое значение (true, false), дающее правильный ответ на вопрос
    var correctAnswer: Bool
}

//Структура модели вопроса нашего квиза
struct QuizStepViewModel {
    //картинка с постером фильма
    var image: UIImage
    
    //Название вопроса
    var question: String
    
    //Порядковый номер вопроса
    var questionNumber: String
    
}

//Структура состояния "результат квиза"
struct QuizResultViewModel {
    //Строка с заголовком alert
    var title: String
    
    //Строка с текстом количества набранных очков
    var text: String
    
    //Текст для кнопки Alert
    var buttonText: String
}

//Моки данные для заполнения массива вопросов квиза

var theGodfather: QuizQuestion = QuizQuestion(image: "The Godfather", text: "Рейтин этого фильма больше чем 6?", correctAnswer: true)

var theDarkKnight: QuizQuestion = QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

var killBill = QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

var theAvengers = QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

var deadpool = QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

var theGreenKnight = QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

var old = QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)

var theIceAgeAdvanturesOfBuckWild = QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)

var tesla = QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)

var vivarium = QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    //Привязываем этикетку со значение счетчика вопросов
    @IBOutlet private weak var counterLabel: UILabel!
    
    //Привязываем изображение постера вопроса
    @IBOutlet private weak var imageView: UIImageView!
    
    //Привязываем этикетку текста вопроса
    @IBOutlet private weak var textLabel: UILabel!
    
    private let questions: [QuizQuestion] = [theGodfather, theDarkKnight, killBill, theAvengers, deadpool, theGreenKnight, old, theIceAgeAdvanturesOfBuckWild, tesla, vivarium]
    
    //Создаем прееменную текущего индекса вопроса
    private var currentQuestionIndex = 0
    
    //Создаем переменную отслеживающую текущее количество правильных ответов
    private var correctAnswers = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Загружаем внешинй вид изображения ImageView в соответствии с моделью в Figma
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        //Загружаем отобрадение первого вопросана экран
        let firstQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: firstQuestion)
        show(quiz: viewModel)
        
    }
    
    //Метод осуществляющий преобразования структуру модели вопроса QuizQuestiion в структур модели отображения на экране QuizStepViewModel
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        var image = UIImage(named: model.image) ?? UIImage()
        var questionText: String = model.text
        var questionNumber: String = "\(currentQuestionIndex + 1)/\(questions.count)"
        
        return QuizStepViewModel(image: image, question: questionText, questionNumber: questionNumber)
    }
    
    //Метод загружающий внешний вид модели QuizStepViewModel на экран
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        imageView.layer.borderColor = .none
    }
    
    //Приватный метод для показа алерта с результатами раунда квиза
    //Принимает модель QuizResultViewModel и ничего не возвращает
    private func showAlert(quiz result: QuizResultViewModel){
        //Создаем Alert
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            // обнуляем счетчик вопросов
            self.correctAnswers = 0
            
            // обнуляем счетчик правильных вопросов
            self.currentQuestionIndex = 0
            
            //Загружаем на экран первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        //Создаем действие Alert и выводим его на экран
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Метод который меняе цвет рамки и вызывает метод перехода
    //метод принимает на въод булево значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypgreen.cgColor : UIColor.ypred.cgColor
        correctAnswers = isCorrect ? correctAnswers + 1 : correctAnswers
        
        //Делаем задержку перед отобрадение следующего вопрос
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showNextQuestionOrResult()
        }
    }
    
    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questions.count - 1 {
            //выводим результаты нашего квиза
            let titleInfoText = "Ваш результат: \(correctAnswers)/\(currentQuestionIndex)"
            let quizResultView = QuizResultViewModel(title: "Этот раунд окончен!", text: titleInfoText, buttonText: "Сыграть ещё раз")
            showAlert(quiz: quizResultView)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: convert(model: nextQuestion))
        }
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        var givenAnswer = true
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer == givenAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        var givenAnswer = false
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer == givenAnswer)
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
