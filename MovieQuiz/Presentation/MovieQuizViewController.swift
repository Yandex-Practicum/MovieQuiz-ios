

import UIKit

final class MovieQuizViewController: UIViewController {
    
//    @IBOutlet private weak var testlabel: UILabel!
    @IBOutlet private weak var labelTitleQuestion: UILabel!
    @IBOutlet private weak var labelQuestionIndex: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var labelQuestion: UILabel!
    @IBOutlet private weak var buttonNo: UIButton!
    @IBOutlet private weak var buttonYes: UIButton!
    
    // Индекс текущего вопроса
    private var currentQuestionIndex = 0
    // Количество правильных ответов
    private var correctAnswers = 0
    // Массив вопросов
    private var questions: [QuizQuestion] = [
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
        
        // У меня Xcode (14.3) не отображает установленные шрифты в списке шрифтов. Перепробовал всё, что рекомендовалось ...
        labelTitleQuestion.font = UIFont(name: "YSDisplay-Medium", size: 20)
        labelQuestionIndex.font = UIFont(name: "YSDisplay-Medium", size: 20)
        labelQuestion.font = UIFont(name: "YSDisplay-Bold", size: 23)
        buttonNo.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        buttonYes.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8     // В соответствии с Figma-моделью
        imageView.layer.cornerRadius = 20   // В соответствии с Figma-моделью
        
        showQuiz()
    }
    
    // Метот вызываемый по нажатию кнопки Нет
    @IBAction private func noButtonClicked(_ sender: UIButton){
        
        // Вызываем реакцию приложения на отрицательный ответ пользователя
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer == false)
    }
    
    // Метот вызываемый по нажатию кнопки Да
    @IBAction private func yesButtonClicked(_ sender: UIButton){
        
        // Вызываем реакцию приложения на утвердительных ответ пользователя
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer == true)
    }
    
    // Подготовка вопроса к визуализации
    private func convert(question: QuizQuestion) -> QuizStepViewModel {
        
        return QuizStepViewModel(
            image: UIImage(named: question.image) ?? UIImage(),
            question: question.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }
    
    // Отображение уведомления о результатах игры
    private func show(quizResult model: QuizResultsViewModel) {
        
        let alert = UIAlertController(title: model.title, message: model.text, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default){ _ in
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.showQuiz()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
    // Смена декораций представления/view
    private func show(quizStep model: QuizStepViewModel){
        
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        labelQuestionIndex.text = model.questionNumber
        imageView.image = model.image
        labelQuestion.text = model.question
    }
   
    // Подготовка представления/view к следующему вопросу
    private func showQuiz(){
        
        let question = questions[currentQuestionIndex]
        let viewModel = convert(question: question)
        
        show(quizStep: viewModel)
    }
   
    // Реагируем на ответ пользователя (нажатие кнопки ответа)
    private func showAnswerResult(isCorrect: Bool){
        
        // Окрашиваем рамку картинки вопроса в соответствии с правильностью ответа
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        if isCorrect {
            // Инкриментируем счётчик верных ответов
            correctAnswers += 1
        }
        
        // Пауза перед следующим вопросом
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults(){
       
        // Если предыдущий вопрос был последним
        if currentQuestionIndex == questions.count - 1 {
            
            // Подготавливаем уведомление
            let text = "Ваш результат: \(correctAnswers)/10"
            let quizResult = QuizResultsViewModel(title: "Раунд окончен!", text: text, buttonText: "Сыграть ещё раз")
            
            // Отображаем уведомление
            show(quizResult: quizResult)
            
        // Иначе переходим к следующему вопросу
        } else {
            
            // Инкриментируем счётчик текущего вопроса
            currentQuestionIndex += 1
            // Отображаем вопрос
            showQuiz()
        }
    }

    
}

struct QuizQuestion {
    // Наименование файла квиза
    let image: String
    // Вопрос квиза
    let text: String
    // Верный ответ
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    
    // Изображение квиза
    let image: UIImage
    // Вопрос квиза
    let question: String
    // Номер вопроса
    let questionNumber: String
}

struct QuizResultsViewModel {
    
    // Заголовок алёрта
    let title: String
    // Строка с текстом о количестве набранных очков
    let text: String
    // Текст для кнопки алёрта
    let buttonText: String
}
