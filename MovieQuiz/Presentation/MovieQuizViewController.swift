import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        textLabel.textColor = .ypWhite
        textLabel.font = .boldSystemFont(ofSize: 23)
        
        
        alertPresenter = AlertPresenter()
        alertPresenter?.controller = self
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader())
        questionFactory?.delegate = self
        questionFactory?.requestNextQuestion()
        
        statisticService = StatisticServiceImplementation()
        questionFactory?.loadData()
        showLoadingIndicator()
        
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: "Невозможно загрузить данные")
    }
    
    private func showNetworkError(message: String) { // функция которая покажет, что произошла ошибка
        hideLoadingIndicator() // скрываем индикатор загрузки
        
        let alertError = UIAlertController(    // создаем и показываем алерт
            title: "Что-то пошло не так(",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: "Попробовать еще раз?",
                                   style: .default) { _ in
    
            
            self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader())
            
            self.questionFactory?.delegate = self

            self.statisticService = StatisticServiceImplementation()

            self.questionFactory?.loadData()
          
            self.showLoadingIndicator()
           
        }
        alertError.addAction(action)
        self.present(alertError, animated: true, completion: nil)
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")// высчитываем номер вопроса// берём текст вопроса
    }
    
    private func convert(model: QuizResultsViewModel, action: @escaping (UIAlertAction) -> Void) -> AlertModel {
        return AlertModel(title: model.title, message: model.text, buttonText: model.buttonText, action: action)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            guard let statisticService = statisticService else {
                print("Сервис статистики не создан")
                return
            }
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let bestGame = statisticService.bestGame ?? GameRecord(correct: correctAnswers, total: questionsAmount, date: Date())
            // показать результат квиза
            let text = "Ваш результат: \(correctAnswers) из \(questionsAmount)\nКоличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз")
            imageView.layer.borderWidth = 0
            let action: (UIAlertAction) -> Void = { _ in
                self.currentQuestionIndex = 0
                self.correctAnswers = 0  // скидываем счетчик правильных ответов
                self.questionFactory?.requestNextQuestion()
            }
            alertPresenter?.show(alert: convert(model: viewModel, action: action))
        } else {
            imageView.layer.borderWidth = 0
            currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1, т.о. мы сможем получить следующий урок
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        // здесь мы показываем верно или нет ответил пользователь
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
}

