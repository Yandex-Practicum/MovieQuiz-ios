import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Private Properties
    
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    
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
        imageView.layer.borderWidth = 1 //0?
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 6 //20?
        
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
    
    // MARK: - Actions
    
    @IBAction private func yesButton(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        let isCorrect = givenAnswer == currentQuestion.correctAnswer
        
        sender.isEnabled = false
        showAnswerResult(isCorrect: isCorrect, sender: sender)
    }
    
    @IBAction private func noButton(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        let isCorrect = givenAnswer == currentQuestion.correctAnswer
        
        sender.isEnabled = false
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
                 self.correctAnswers = 0// скидываем счётчик правильных ответов
                 self.questionFactory?.requestNextQuestion() // заново показываем первый вопрос
             }
        
        self.alertPresenter?.showAlert(alertModel)
     }
    
    private func showAnswerResult(isCorrect: Bool, sender: UIButton) {
        if isCorrect {
            correctAnswers += 1
        }
    
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            sender.isEnabled = true
        }
    }
    
        private func showNextQuestionOrResults() {
            yesButton.isEnabled = true
            noButton.isEnabled = true
        if currentQuestionIndex == questionsAmount - 1 {
                    guard let statisticService = statisticService else { return }
                    statisticService.store(correct: correctAnswers, total: questionsAmount)
                    let bestGameRes = "\(statisticService.bestGame.correct)/\(statisticService.bestGame.total)"
                    let text = """
                    Ваш результат: \(correctAnswers) из \(questionsAmount)
                    Количество сыгранных квизов:\(statisticService.gamesCount)
                    Рекорд: \(bestGameRes)/ \(statisticService.bestGame.date.dateTimeString)
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
//        statisticService?.store(correct: correctAnswers, total: questionsAmount)
//        Количество сыграных квизов: \(statisticService?.gamesCount ?? 1)
//                    Рекорд: \(statisticService?.bestGame.correct ?? 0)/\(statisticService?.bestGame.total ?? 10) \(statisticService?.bestGame.date.dateTimeString ?? Date().dateTimeString)
//                    Cредняя точность: \(statisticService?.totalAccurancy ?? 0)%
//                    """
    
    
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
