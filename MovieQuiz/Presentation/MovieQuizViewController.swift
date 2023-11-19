import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegatePrototocol {
    // MARK: - Lifecycle
    
    //Привязываем этикетку со значение счетчика вопросов
    @IBOutlet private weak var counterLabel: UILabel!
    
    //Привязываем изображение постера вопроса
    @IBOutlet private weak var imageView: UIImageView!
    
    //Привязываем этикетку текста вопроса
    @IBOutlet private weak var textLabel: UILabel!
    
    //Привязываем кнопку "Да" к коду
    @IBOutlet private weak var yesButton: UIButton!
    
    //Привязываем кнопку "Нет" к коду
    @IBOutlet private weak var noButton: UIButton!
    
    //Создаем прееменную текущего индекса вопроса
    private var currentQuestionIndex = 0
    
    //Создаем переменную отслеживающую текущее количество правильных ответов
    private var correctAnswers = 0
    
    //Определяем переменны необходимые для связи MobieQuizViewController c "Фабрикой вопросов"
    //Определяем максимальное количество вопросов
    private var questionAmount: Int = 10
    
    //Определяем "Фабрику впоросов"
    private lazy var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    
    //Вопрос, который видит пользователь
    private var currentQuestion: QuizQuestion?
    
    
    //Определяем внешний вид статус бара в приложении
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //инъекция зависимости для определения делегата
        questionFactory.delegate = self
        
        //Загружаем внешинй вид изображения ImageView в соответствии с моделью в Figma
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        //Загружаем отобрадение первого вопросана экран
        questionFactory.requestNextQuestion()
        
        //Загружаем необходимый вид статус бара
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
    }
    
    func didFinishReceiveQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
        show(quiz: viewModel)
    }
    
    //Метод осуществляющий преобразования структуру модели вопроса QuizQuestiion в структур модели отображения на экране QuizStepViewModel
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let image = UIImage(named: model.image) ?? UIImage()
        let questionText: String = model.text
        let questionNumber: String = "\(currentQuestionIndex + 1)/\(questionAmount)"
        
        return QuizStepViewModel(image: image, question: questionText, questionNumber: questionNumber)
    }
    
    //Метод блокировки кнопок экрана
    private func isButtonsBlocked(state: Bool) {
        if state {
            yesButton.isEnabled = false // Запрещаем действие кнопки "Да"
            noButton.isEnabled = false // Запрещаем действие кнопки "Нет"
        } else {
            yesButton.isEnabled = true // Разрешаем действие кнопки "Да"
            noButton.isEnabled = true // Разрешаме действие кнопки "Нет"
        }
    }
    
    //Метод загружающий внешний вид модели QuizStepViewModel на экран
    private func show(quiz step: QuizStepViewModel) {
        
        UIView.transition(with: imageView,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: {
            self.imageView.image = step.image
            self.imageView.layer.borderWidth = 0 //Скраваем рамку
        },
                          completion: { _ in
            self.textLabel.text = step.question
            self.counterLabel.text = step.questionNumber
            self.isButtonsBlocked(state: false) // Разрешаем действе действие кнопок
        })
    }
    
    //Приватный метод для показа алерта с результатами раунда квиза
    //Принимает модель QuizResultViewModel и ничего не возвращает
    private func showAlert(quiz result: QuizResultViewModel){
        //Создаем Alert
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            
            guard let selfAction = self else { return }
            // обнуляем счетчик вопросов
            selfAction.correctAnswers = 0
            
            // обнуляем счетчик правильных вопросов
            selfAction.currentQuestionIndex = 0
            
            //Загружаем на экран первый вопрос
            selfAction.questionFactory.requestNextQuestion()
        }
        
        //Создаем действие Alert и выводим его на экран
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Метод который меняе цвет рамки и вызывает метод перехода
    //метод принимает на въод булево значение и ничего не возвращает
    
    private func showAnswerResult(isCorrect: Bool) {
        
        isButtonsBlocked(state: true) // Запрещаем действие кнопок
        imageView.layer.borderWidth = 8 // Показываем рамку
        
        if isCorrect {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypgreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypred.cgColor
        }
        
        //Делаем задержку перед отобрадение следующего вопрос
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
            guard let dispatch = self else { return }
            dispatch.showNextQuestionOrResult()
            
        }
    }
    
    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questionAmount - 1 {
            //выводим результаты нашего квиза
            let titleInfoText = correctAnswers == questionAmount ? "Поздрвляем вы ответели на 10 и 10!" : "Вы ответели на \(correctAnswers) из \(questionAmount), попробуйте ещё раз!"
            let quizResultView = QuizResultViewModel(title: "Этот раунд окончен!", text: titleInfoText, buttonText: "Сыграть ещё раз")
            showAlert(quiz: quizResultView)
        } else {
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
        }
    }
    
    //Определяем действие кнопки "Да"
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion else { return }
        let givenAnswer = true
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == givenAnswer)
    }
    
    //Определяем действие кнопки "Нет"
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion else { return }
        let givenAnswer = false
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == givenAnswer)
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
