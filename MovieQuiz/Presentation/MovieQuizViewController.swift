import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Variables
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    /// переменная с индексом текущего вопроса
    private var currentQuestionIndex = 0
    /// переменная со счётчиком правильных ответов
    private var correctAnswers = 0
    /// переменная с заданным кол-вом вопросов
    private let questionsAmount: Int = 2
    /// фабрика вопросов
    private var questionFactory: QuestionFactoryProtocol?
    /// текущий вопрос
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?

    // делаем статус бар светлым
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20 // скругление рамки
        
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        questionFactory?.requestNextQuestion()
        
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
                return
            }
            
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }
    }
    

    
    // MARK: - Private Methods
    // метод конвертации, который принимает мок данные и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        /// делаем кнопки активными
        answerButtons(isEnabled: true)
    }
    
    /// устанавливаем флаг на вкл. или откл. кнопок
    private func answerButtons(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    // приватный метод, который меняет цвет рамки
    private func showAnswerResult(isCorrect: Bool) {
        /// блокируем кнопки до появляения следующешо вопроса
        answerButtons(isEnabled: false)
        
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        UIView.animate(withDuration: 2.0, animations: {
            self.imageView.layer.borderColor = UIColor.clear.cgColor
        })
        
        if isCorrect {
            correctAnswers += 1
        }
        
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            // код, который мы хотим вызвать через 1 секунду
            self.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    // рестарт игры
    private func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    private func showNextQuestionOrResults() {
        // если вопросов больше нет, отображаем алерт
        if currentQuestionIndex == questionsAmount - 1 {
            let text = questionsAmount == correctAnswers ?
            "Поздравляем! Вы ответили на \(questionsAmount) из \(questionsAmount)!" :
            "Ваш результат: \(correctAnswers)/\(questionsAmount)"
            
            let viewModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть еще раз",
                completion: { [weak self] in
                    guard let self = self else { return }
                    self.restartGame()
                })
            alertPresenter?.show(model: viewModel)
        } else {
            // иначе считаем количество вопросов
            currentQuestionIndex += 1
            
            questionFactory?.requestNextQuestion()
        }
    }
    
    // MARK: - IBActions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer)
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = false

        showAnswerResult(isCorrect: givenAnswer)
    }
}
