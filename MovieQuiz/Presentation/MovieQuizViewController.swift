import UIKit

// добавляем в объявление класса реализацию протокола делегата
final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    private var alertPresenter: AlertPresenterProtocol?
    
    // переменные из экрана
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    /// переменная с индексом текущего вопроса, начальное значение 0
    private var currentQuestionIndex = 0
    /// переменная со счётчиком правильных ответов, начальное значение закономерно 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // текущий вопрос - вопрос из массива по индексу текушеко вопроса
        // инъекция через свойство, поэтому задаем делегата в методе
        questionFactory = QuestionFactory(delegate: self)
        // исправляем ошибки (1)
        questionFactory?.requestNextQuestion()
        // alertPresenter
        alertPresenter = AlertPresenter(viewController: self)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Private functions
    /// метод конвертации, принимаем моковый вопрос и возвращаем вью модель для экрана вопросов
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            // исправляем ошибки (4)
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    /// метод для показа результатов раунда квиза
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: { [weak self] in guard let self else { return }
            self.imageView.layer.borderColor = nil
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            // исправляем ошибки (5)
            self.questionFactory?.requestNextQuestion()
        })
        alertPresenter?.show(with: alertModel)
    }
    /// метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        imageView.layer.borderWidth = 0
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    /// метод, содержащий логику перехода в один из сценариев
    private func showNextQuestionOrResults() {
        // исправляем ошибки (6)
        if currentQuestionIndex == questionsAmount - 1 {
            // идем в состояние "Результат квиза"
                let alertModel = AlertModel(title: "Этот раунд окончен!", message: "Ваш результат: \(correctAnswers)/10", buttonText: "Сыграть еще раз", completion: { [weak self] in guard let self else { return }
                    self.imageView.layer.borderColor = nil
                    self.currentQuestionIndex = 0
                    self.correctAnswers = 0
                    // исправляем ошибки (5)
                    self.questionFactory?.requestNextQuestion()
                })
                alertPresenter?.show(with: alertModel)

            
            
        } else {
            currentQuestionIndex += 1
            // идем в состояние "Вопрос показан"
            // исправляем ошибки (7)
            questionFactory?.requestNextQuestion()
        }
    }
    
    /// метод, меняющий не только цвет рамки
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        yesButton.isEnabled = false
        noButton.isEnabled = false
        if isCorrect {correctAnswers += 1}
        
        /// запускаем через 1 секунду с помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in guard let self = self else { return }
            /// код, который мы хотим вызвать через 1 секунду
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
            self.showNextQuestionOrResults()
        }
    }
    
    // MARK: - Actions
    /// нажатие на "ДА"
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        // исправляем ошибки (2)
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    /// нажатие на "НЕТ"
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        // исправляем ошибки (3)
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
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
