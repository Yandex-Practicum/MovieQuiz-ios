//
// Sprint 05 branch
//

import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var questionIndexLabel: UILabel!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    /// Индекс текущего вопроса
    private var currentQuestionIndex = 0
    /// Количество правильных ответов
    private var correctAnswers = 0
    /// Массив вопросов
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
        
        // У меня Xcode (14.3) не отображает установленные шрифты в списке шрифтов. Перепробовал всё, что рекомендовалось, поэтому ...
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionIndexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        mainImageView.layer.masksToBounds = true
        mainImageView.layer.borderWidth = 8     // В соответствии с Figma-моделью
        mainImageView.layer.cornerRadius = 20   // В соответствии с Figma-моделью
        
        showQuiz()
    }
    
    // Окрашиваем статусную панель в светлые тона
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// Метод вызываемый по нажатию кнопки Нет
    @IBAction private func noButtonClicked(_ sender: UIButton){
        
        // Вызываем реакцию приложения на отрицательный ответ пользователя
        toggleButtons(to: false)
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer == false)
    }
    
    /// Метод вызываемый по нажатию кнопки Да
    @IBAction private func yesButtonClicked(_ sender: UIButton){
        
        // Вызываем реакцию приложения на утвердительных ответ пользователя
        toggleButtons(to: false)
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer == true)
    }
    
    /// Метод включающий/выключающий кнопки ответов
    ///  - Parameters:
    ///     - to: Состояние в которое переводится свойство кнопок isEnabled, true - включаем кнопки, false - отключаем
    private func toggleButtons(to state: Bool){
        noButton.isEnabled = state
        yesButton.isEnabled = state
    }
    
    /// Подготовка вопроса к визуализации
    /// - Parameters:
    ///     - question: QuizQuestion-структура
    /// - Returns: Возвращает структуру "QuizStepViewModel" для отображения вопроса в представлении
    private func convert(question: QuizQuestion) -> QuizStepViewModel {
        
        return QuizStepViewModel(
            image: UIImage(named: question.image) ?? UIImage(),
            question: question.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }
    
    /// Отображение уведомления о результатах игры
    /// - Parameters:
    ///     - quizResult: QuizResultsViewModel-структура
    private func show(quizResult model: QuizResultsViewModel) {
        
        let alert = UIAlertController(title: model.title, message: model.text, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default){ [ weak self ] _ in
            
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.showQuiz()
            
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
    /// Смена декораций представления/view
    ///  - Parameters
    ///     - quizStep: QuizStepViewModel-структура, содержащая необходимые элементы для обновления представления
    ///
    private func show(quizStep model: QuizStepViewModel){
        
        mainImageView.layer.borderColor = UIColor.clear.cgColor
        
        questionIndexLabel.text = model.questionNumber
        mainImageView.image = model.image
        questionLabel.text = model.question
        
        toggleButtons(to: true)
    }
   
    /// Подготовка представления/view к следующему вопросу
    private func showQuiz(){
        
        let question = questions[currentQuestionIndex]
        let viewModel = convert(question: question)
        
        show(quizStep: viewModel)
    }
   
    /// Реагируем на ответ пользователя (нажатие кнопки ответа) - окрашиваем рамку картинки, переходим к следующему вопросу
    /// - Parameters:
    ///     - isCorrect: индикатор верности ответа
    private func showAnswerResult(isCorrect: Bool){
        
        // Окрашиваем рамку картинки вопроса в соответствии с правильностью ответа
        mainImageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        if isCorrect {
            // Инкриментируем счётчик верных ответов
            correctAnswers += 1
        }
        
        // Пауза перед следующим вопросом
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){ [weak self] in
            self?.showNextQuestionOrResults()
        }
    }
    
    /// Отображение следующего вопроса или результатов
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

/// Структура вопроса
/// - Parameters:
///     - image: Наименование используемого файла
///     - text: Текст вопроса
///     - correctAnswer: Верный Ответ на вопрос
struct QuizQuestion {
    
    let image: String
    let text: String
    let correctAnswer: Bool
}

/// Структура модели вопроса
/// - Parameters:
///     - image: Изображение вопроса
///     - question: Текст вопроса
///     - questionNumber: Номер вопроса в квизе
struct QuizStepViewModel {
    
    let image: UIImage
    let question: String
    let questionNumber: String
}

/// Структура модели отображаемого уведомления с результатами
/// - Parameters:
///     - title: Заголовок уведомления
///     - text: Строка с текстом о количестве набранных очков
///     - buttonText: Текст кнопки уведомления
struct QuizResultsViewModel {
    
    let title: String
    let text: String
    let buttonText: String
}
