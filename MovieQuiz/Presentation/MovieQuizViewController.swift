import UIKit

final class MovieQuizViewController: UIViewController {
  
    
    private var currentQuestionIndex : Int = 0
    private var correctAnswers : Int = 0
    private let questions : [QuizQuestion] = [
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
    
    //Статус бар в белый
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //Изображение создано и готово к показу
   override func viewDidLoad() {
        super.viewDidLoad()
        //показ первого вопроса
        let nextQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: nextQuestion)
        show(quiz: viewModel)
        
    }
    
    // View собираются показать
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
         тут имеет смысл дополнительно настроить наши изображения, например задать цвет фона
         */
    }
    
    // View уже показали
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
         тут имеет смысл собирать аналитику когда экран показали
         */
    }
    
    // view собираются перестать показывать
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /*
         тут имеет смысл остановить все процессы происходившие на экране
         */
    }
    
    // view перестали показывать
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        /*
         Тут имеет смысл оповестить систему аналитики, что экран перестал показываться и привести его в изначальное состояние.
         */
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
    
    // Реализация логики приложения
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    
    @IBOutlet private var imageView: UIImageView! //изображение фильма
    
    @IBOutlet private var textLabel: UILabel! //текст вопроса
    
    @IBOutlet private var counterLabel: UILabel! // счетчик вопросов counterLabel
    
    // Функции кнопок
    // Нажатие кнопки НЕТ
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let giveAnswer = false
        showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
        
    }
    //  Нажатие кнопки ДА
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let giveAnswer = true
        showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
    }
    
    // здесь мы заполняем нашу картинку, текст и счётчик данными
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    //здесь мы показываем результат прохождения квиза
    private func show(quiz result: QuizResultsViewModel){
        let alert = UIAlertController(
            title: result.title, message: result.text, preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) {_ in
            self.currentQuestionIndex = 0
            
            //счетчик правильных ответов в 0
            self.correctAnswers = 0
            
            // Заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Функция конвертации из QuizQuestion в QuizStepViewModel
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // высчитываем номер вопроса
    }
    
    //состояние показа результата ответа
    private func showAnswerResult(isCorrect: Bool) {
        //счетчик правильных ответов
        if isCorrect {
            correctAnswers += 1
        }
        //Рамки в зеленый
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.green.cgColor : UIColor.red.cgColor
        
        // Запуск следующего вопроса через 1 секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            self.showNextQuestionOrResults()
        }
    }
    
    //показ следующего вопроса или результата
    private func showNextQuestionOrResults(){
        if currentQuestionIndex == questions.count - 1 {
            // показать результат
            let text = "Ваш результат: \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен", text: text, buttonText: "Сыграть еще раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1 // увеличим индекс вопроса на + 1
            // показать вопрос
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        }
    }
    
}

