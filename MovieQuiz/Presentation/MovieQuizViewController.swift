import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    //аутлет кнопки да
    @IBOutlet weak var yesButton: UIButton!
    
    // аутелт кнопки нет
    @IBOutlet weak var noButton: UIButton!
    
    //аутлет изображения
    @IBOutlet weak private var imageView: UIImageView!
    
    //аутлет афиши фильма
    @IBOutlet weak private var textLabel: UILabel!
    
    //аутлет счетчика вопросов
    @IBOutlet weak private var counterLabel: UILabel!
    
    
    // переменная с индексом текущего вопроса, начальное значение 0
    private var currentQuestionIndex = 0
    
    // переменная со счётчиком правильных ответов, начальное значение закономерно 0
    private var correctAnswers = 0
    
    //общее количество вопросов
    private let questionsAmount: Int = 10
    
    //обращение к протоколу фабрики вопросов
    private var questionFactory: QuestionFactoryProtocol?
    
    //текущий вопрос, который видит пользователь
    private var currentQuestion: QuizQuestion?
    
    private lazy var alertPsenenter = AlertPresenter(viewController: self)
    
    private var statisticService: StatisticService?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticService = StatisticServiceImplementation()
    
        //обращение к фабрике вопросов
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        
        //скругление углов у афиши фильма
        imageView.layer.cornerRadius = 20
    }
    
    //событие кнопки да
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        //распаковка опционала для хранения текущего вопроса
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = true
            
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    //событие кнопки нет
    @IBAction private func noButtonClicked(_ sender: UIButton) {
       
        //распаковка опционала для хранения текущего вопроса
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in self?.show(quiz: viewModel) }
    }
    
    
    // приватный метод, который меняет цвет рамки
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
               correctAnswers += 1
           }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        //отключает активность кнопок после нажатия на ответ
        self.yesButton.isEnabled = false
        self.noButton.isEnabled = false
        
        ///реализована корректная работа замыкания
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
            
            self?.imageView.layer.borderWidth = 0
            
            //включает активность кнопок после показа следующего вопроса
            self?.yesButton.isEnabled = true
            self?.noButton.isEnabled = true
            }
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса
    private func show(quiz step: QuizStepViewModel) {
      imageView.image = step.image
      textLabel.text = step.question
      counterLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let completion = {
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
                }
        let alertModel = AlertModel(
                    title: result.title,
                    message: result.text,
                    buttonText: result.buttonText,
                    completion: completion)
        
        alertPsenenter.showResultsAlert(alertModel)
    }
    
    // приватный метод конвертации, который принимает моковый вопрос и возвращает вью модель для главного экрана
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    //изменяет статус бар на белый
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            if let statisticService = statisticService {
                
                statisticService.store(correct: correctAnswers, total: questionsAmount)
                
                let gamesCount = statisticService.gamesCount
                let bestGame = statisticService.bestGame
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.YY HH:mm"
                
                let text = """
                                Ваш результат: \(correctAnswers) из 10
                                Количество сыгранных квизов: \(gamesCount)
                                Ваш рекорд: \(bestGame.correct)/\(bestGame.total) (\(dateFormatter.string(from: bestGame.date)))
                                Средняя точность: (\(String(format: "%.2f", statisticService.totalAccuracy))%)
                            """
                
                let viewModel = QuizResultsViewModel(
                                    title: "Этот раунд окончен!",
                                    text: text,
                                    buttonText: "Сыграть ещё раз")
                                show(quiz: viewModel)
            }
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
            
        }
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
