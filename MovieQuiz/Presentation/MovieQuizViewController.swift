import UIKit



final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Lifecycle
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService = StatisticServiceImplementation()
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        // преобразовываем данные модели вопроса в те, что нужно показать на экране
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showQuestion(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.showQuestion(quiz: viewModel)
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        // отображаем результат ответа (выделяем рамкой верный или неверный ответ)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen?.cgColor : UIColor.ypRed?.cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
            self.showQuestionOrResult()
        }
    }
    
    private func showQuestionOrResult() {
        
        if currentQuestionIndex == questionsAmount - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
            // показать результат квизa
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let textMessage =
            """
            Ваш результат: \(correctAnswers) из 10,
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
            let alert = AlertModel(title: "Этот раунд окончен!", message: textMessage, buttonText: "Cыграть еще раз") { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                guard let currentQuestion = self.currentQuestion else { return }
                let firstQuestionModel = self.convert(model: currentQuestion)
                self.showQuestion(quiz: firstQuestionModel)
            }
            alertPresenter?.present(model: alert)
            correctAnswers = 0
            questionFactory?.requestNextQuestion()
        } else {
            currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий вопрос
            // показать следующий вопрос
            questionFactory?.requestNextQuestion()
        }
    }
    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        // проверка ответа
        let userAnswer = false
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        // проверка ответа
        let userAnswer = true
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
}
