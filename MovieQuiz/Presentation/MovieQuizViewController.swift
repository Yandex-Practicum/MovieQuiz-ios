import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    private var statisticService: StatisticService?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    // private let questionsAmount: Int = 10
    // private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 20
        
        statisticService = StatisticServiceImplementation()
        
        // questionFactory = QuestionFactory(delegate: self)
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        //questionFactory?.requestNextQuestion()
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        
        //let viewModel = convert(model: question)
        let viewModel = presenter.convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        if currentQuestion.correctAnswer == true {
            self.showAnswerResult(isCorrect: true)
        } else {
            self.showAnswerResult(isCorrect: false)
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        if currentQuestion.correctAnswer == false {
            self.showAnswerResult(isCorrect: true)
        } else {
            self.showAnswerResult(isCorrect: false)
        }
    }
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        /*
        if self.currentQuestionIndex < self.questionsAmount - 1 {
            self.currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        } else {
            let title = "Этот раунд окончен!"
            let message =
                "Ваш результат: \(self.correctAnswers)/\(self.questionsAmount)\n" +
                "Количество сыгранных квизов: \(self.currentQuestionIndex + 1)\n"
            let buttonText = "Сыграть ещё раз"
            self.show(quiz: QuizResultsViewModel(title: title, text: message, buttonText: buttonText))
        }
        */
        if self.presenter.isLastQuestion() {
            let title = "Этот раунд окончен!"
            let message =
            "Ваш результат: \(self.correctAnswers)/\(self.presenter.getQuestionAmount())\n" +
            "Количество сыгранных квизов: \(self.presenter.getQuizAmount())\n"
            let buttonText = "Сыграть ещё раз"
            self.show(quiz: QuizResultsViewModel(title: title, text: message, buttonText: buttonText))
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    /*
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    */
    
    /*
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    */
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        self.counterLabel.text = step.questionNumber
        self.imageView.image = step.image
        self.textLabel.text = step.question
    }
    
    // приватный метод для показа результатов раунда квиза
    // принимает вью модель QuizResultsViewModel и ничего не возвращает
    private func show(quiz result: QuizResultsViewModel) {
        let action: (() -> Void) = { [weak self] in
            guard let self = self else { return }
            
            self.correctAnswers = 0
            // self.currentQuestionIndex = 0
            
            self.presenter.resetQuestionIndex()
            self.questionFactory?.requestNextQuestion()
        }
        
        // self.statisticService?.store(correct: self.correctAnswers, total: self.currentQuestionIndex)
        self.statisticService?.store(correct: correctAnswers, total: presenter.getQuestionAmount())
        
        let message: String
        
        if let gamesCount = self.statisticService?.gamesCount,
           let correct = self.statisticService?.bestGame.correct,
           let total = self.statisticService?.bestGame.total,
           let date = self.statisticService?.bestGame.date,
           let totalAccuracy = self.statisticService?.totalAccuracy {
            message =
            "Ваш результат: \(self.correctAnswers)/\(self.presenter.getQuestionAmount())\n" +
          "Количество сыгранных квизов: \(gamesCount)\n" +
            "Рекорд: \(correct)/\(total) (\(date.dateTimeString))\n" +
          "Средняя точность: \(String(format: "%.2f", totalAccuracy))%"
        } else {
            message = result.text
        }
        
        let alertModel = AlertModel(
            title: result.title,
            message: message,
            buttonText: result.buttonText,
            completion: action)
        
        let alertPresenter = AlertPresenter(controller: self, model: alertModel)
        alertPresenter.run()
    }
    
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            self.correctAnswers += 1
            self.imageView.layer.borderColor = UIColor(named: "YP Green")?.cgColor
        } else {
            self.imageView.layer.borderColor = UIColor(named: "YP Red")?.cgColor
        }
        
        self.imageView.layer.borderWidth = 8
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        
        let action: (() -> Void) = { [weak self] in
            guard let _ = self else { return }
            // действия при нажатии на кнопку алерта
        }
        
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: action)
        
        //self.currentQuestionIndex = 0
        self.presenter.resetQuestionIndex()
        self.correctAnswers = 0

        self.questionFactory?.requestNextQuestion()
        
        let alertPresenter = AlertPresenter(controller: self, model: alertModel)
        alertPresenter.run()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }

    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
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
