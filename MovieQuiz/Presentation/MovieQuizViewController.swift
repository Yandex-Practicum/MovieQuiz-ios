import UIKit
// MARK: - Lifecycle

final class MovieQuizViewController: UIViewController {
    
    //Делаем statusBar белый
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //создаем переменные
    private var currentQuestionIndex: Int = 0 // переменная отвечающая за индекс текущего вопроса
    private var correctAnswer: Int = 0 // перемення отвечающая за количество правильных ответов
    
    //создаем массив с данными
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: false)
    ]
    //создаем структуры
    
    // для состояния "Вопрос задан"
    struct QuizStepViewModel{
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    // для состояния "Результат квиза"
    struct QuizResultViewModel{
        let title: String
        let text: String
        let buttonText: String
    }
    // для состояния задания вопроса
    struct QuizQuestion{
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    //аутлеты
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    //нажатие на кнопку "ДА"
    @IBAction private func noButtonClicked(_ sender: Any) {
        switchOnOffButton()
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    //нажатие на кнопку "НЕТ"
    @IBAction private func yesButtonClicked(_ sender: Any) {
        switchOnOffButton()
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func switchOnOffButton(){
        noButton.isEnabled.toggle()
        yesButton.isEnabled.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // показываем первый экран
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
    }
    
    // создаем функцию для показа карточки
    private func show(quiz step: QuizStepViewModel){
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // создаем функцию для показа результата квиза
    private func show(quiz result: QuizResultViewModel){
        // здесь мы показываем результат прохождения квиза
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            
            //скидывем счетчик правильных ответов
            self.correctAnswer = 0
            
            //заново показывем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
        imageView.layer.borderWidth = 0
    }
    
    // создаем функцию конверации
    private func convert(model: QuizQuestion) -> QuizStepViewModel{
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // забираем текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // высчислем номер вопроса
    }
    
    // создаем функцию состояния показа результата ответа
    private func showAnswerResult(isCorrect: Bool){
        // счетчик правильных ответов
        if isCorrect == true{
            correctAnswer += 1
        }
        //рисуем рамки
        imageView.layer.masksToBounds = true // разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // если правильно рисуем рамку зеленой, если нет красной
        imageView.layer.cornerRadius = 20 // скругление углов
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showNextQuestionOrResult()
            self.switchOnOffButton()
        }
    }
    
    // создаем функцию состояния показа следующего вопроса или показ результата
    private func showNextQuestionOrResult(){
        if currentQuestionIndex == questions.count - 1{
            // показываем результат на алерте
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 0
            let text = "Ваш результат: \(correctAnswer) из 10"
            let viewModel = QuizResultViewModel(
                title: "Этот раунд закончен!",
                text: text,
                buttonText: "Сыграть еще раз")
            
            show(quiz: viewModel)
            
        }else{
            currentQuestionIndex += 1
            // показываем вопрос
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 0
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        
        }
    }
    
    
    
}
