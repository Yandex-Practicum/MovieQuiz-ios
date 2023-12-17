import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // настраиваем внешний вид рамки
        setupImageView()
        // запрашиваем первый вопрос
        questionFactory.delegate = self
        questionFactory.requestNextQuestion()
        alertPresenter.delegate = self
    }
    
    // связь объектов из main-экрана с контроллером
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    // переменная с индексом текущего вопроса, начальное значение 0
    private var currentQuestionIndex = 0
    // переменная со счётчиком правильных ответов, начальное значение закономерно 0
    private var correctAnswers = 0
    // константа с количеством вопросов
    private let questionsAmount: Int = 10
    // переменная инициализирует создание объекта с вопросами
    private let questionFactory = QuestionFactory()
    // переменная с текущим вопросом
    private var currentQuestion: QuizQuestion?
    private let alertPresenter = AlertPresenter()
    
    // MARK: Настройка внешнего вида
    
    // приватный метод визуализации рамки
    private func setupImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
    }
    
    // приватный метод отключения/включения кнопок
    private func setAnswerButtonsEnabled(_ enabled: Bool) {
        noButton.isEnabled = enabled
        yesButton.isEnabled = enabled
    }
    
    // MARK: Обработка логики
    
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
    
    func alertDidDismiss() {
        startNewRound()
    }
    
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1) / \(questionsAmount)")
    }
    
    // метод проверяет как ответил пользователь
    private func checkResultAnswer(isCorrect: Bool) -> Bool {
        if let question = currentQuestion, isCorrect == question.correctAnswer {
            correctAnswers += 1
            return true
        }
        return false
    }
    
    // метод отвечающий за старт нового раунда квиза
    private func startNewRound() {
        currentQuestionIndex = 0
        correctAnswers = 0
        setAnswerButtonsEnabled(true)
        questionFactory.requestNextQuestion()
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            // Если это последний вопрос, показываем результаты
            showQuizResults()
        } else {
            // Плавный переход к следующему вопросу + анимация
            UIView.transition(with: self.view, duration: 2.0, options: .transitionCurlUp, animations: {
                self.currentQuestionIndex += 1
                self.setAnswerButtonsEnabled(true) // Включаем кнопки перед показом нового вопроса
                self.questionFactory.requestNextQuestion()
            }, completion: nil)
        }
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func showQuizResults() {
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: "Ваш результат \(correctAnswers) / \(questionsAmount)",
            buttonText: "Сыграть еще раз"
        )
        alertPresenter.present(alertModel: alertModel, on: self)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
        }
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        setAnswerButtonsEnabled(false)
        showAnswerResult(isCorrect: checkResultAnswer(isCorrect: false))
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        setAnswerButtonsEnabled(false)
        showAnswerResult(isCorrect: checkResultAnswer(isCorrect: true))
    }
}
