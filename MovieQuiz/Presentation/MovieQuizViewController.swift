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
    
    /// Количество вопросов в игре
    private let questionsAmount: Int = 10
    /// Фабрика вопросов
    private let questionFactory: QuestionFactoryProtocol = QuestionFactory()
    /// Текущий вопрос
    private var currentQuestion: QuizQuestion?
    
    
    // Окрашиваем статусную панель в светлые тона
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
    
    /// Метод вызываемый по нажатию кнопки Нет
    @IBAction private func noButtonClicked(_ sender: UIButton){
        
        // Вызываем реакцию приложения на отрицательный ответ пользователя
        toggleButtons(to: false)
        
        guard let currentQuestion = currentQuestion else { return }
        
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
    
    /// Метод вызываемый по нажатию кнопки Да
    @IBAction private func yesButtonClicked(_ sender: UIButton){
        
        // Вызываем реакцию приложения на утвердительных ответ пользователя
        toggleButtons(to: false)
        
        guard let currentQuestion = currentQuestion else { return }
        
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
    
    /// Подготовка представления/view к следующему вопросу
    private func showQuiz(){
        
        // получаем следующий произвольный вопрос
        currentQuestion = questionFactory.requestNextQuestion()
        
        guard let question = currentQuestion else {
            return
        }
        
        let viewModel = convert(question: question)
        
        show(quizStep: viewModel)
    }
    
    /// Подготовка вопроса к визуализации
    /// - Parameters:
    ///     - question: QuizQuestion-структура
    /// - Returns: Возвращает структуру "QuizStepViewModel" для отображения вопроса в представлении
    private func convert(question: QuizQuestion) -> QuizStepViewModel {
        
        return QuizStepViewModel(
            image: UIImage(named: question.image) ?? UIImage(),
            question: question.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    /// Смена декораций представления/view
    ///  - Parameters
    ///     - quizStep: QuizStepViewModel-структура, содержащая необходимые элементы для обновления представления
    ///
    private func show(quizStep model: QuizStepViewModel){
        
        // Убираем окраску рамки изображения
        mainImageView.layer.borderColor = UIColor.clear.cgColor
        
        // Адаптируем интерфейс под новый вопрос
        questionIndexLabel.text = model.questionNumber
        mainImageView.image = model.image
        questionLabel.text = model.question
        
        // Включаем кнопки
        toggleButtons(to: true)
    }
    
    /// Метод включающий/выключающий кнопки ответов
    ///  - Parameters:
    ///     - to: Состояние в которое переводится свойство кнопок isEnabled, true - включаем кнопки, false - отключаем
    private func toggleButtons(to state: Bool){
        noButton.isEnabled = state
        yesButton.isEnabled = state
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
        if currentQuestionIndex == questionsAmount - 1 {
            
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
