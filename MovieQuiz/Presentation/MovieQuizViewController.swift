import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    
    @IBOutlet weak var yesButtonOutlet: UIButton!
    @IBOutlet weak var noButtonOutlet: UIButton!
    
    
    
    private var correctAnswers = 0
    private var currentQuestionIndex = 0
    private var numberOfRounds = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(viewController: self)
        statisticService = StatisticServiceImplementation()
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 20
        
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButton(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        let isCorrect = givenAnswer == currentQuestion.correctAnswer
        
        yesButtonOutlet.isEnabled = false
        noButtonOutlet.isEnabled = false
        showAnswerResult(isCorrect: isCorrect, sender: sender)
    }
    
    @IBAction private func noButton(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        let isCorrect = givenAnswer == currentQuestion.correctAnswer
        
        noButtonOutlet.isEnabled = false
        yesButtonOutlet.isEnabled = false
        showAnswerResult(isCorrect: isCorrect, sender: sender)
    }
    
    
    // MARK: - Private functions
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),// распаковываем картинку
            question: model.text,// берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")// высчитываем номер вопроса
        return questionStep
    }
    
    // приватный метод для показа результатов раунда квиза (заполняем нашу картинку, текст и счётчик данными), принимает вью модель QuizResultsViewModel и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func show (quiz result: QuizResultsViewModel) {
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        
        let alertModel  = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText, completion: { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0 // скидываем счётчик правильных ответов
                self.questionFactory?.requestNextQuestion() // заново показываем первый вопрос
            } )
        self.alertPresenter?.showAlert(alertModel)
    }
    
    private func showAnswerResult(isCorrect: Bool, sender: UIButton) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            self.noButtonOutlet.isEnabled = true
            self.yesButtonOutlet.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questionsAmount - 1 {
            guard let statisticService = statisticService else { return }
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let text = """
                    Ваш результат: \(correctAnswers) из \(questionsAmount)
                    Количество сыгранных квизов:\(statisticService.gamesCount)
                    Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total)(\(statisticService.bestGame.date.dateTimeString))
                    Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy) + "%")
                    """
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
}

// MARK: - QuestionFactoryDelegate

extension MovieQuizViewController: QuestionFactoryDelegate {
    
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
}
