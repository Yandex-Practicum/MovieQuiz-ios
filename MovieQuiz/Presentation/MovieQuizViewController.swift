import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    private var correctAnswers: Int = 0
    var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewController = self
        
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
        yesButton.isEnabled = true
        noButton.isEnabled = true
        guard let question = question else {
            return
        }
        presenter.currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        currentQuestion = presenter.currentQuestion
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        currentQuestion = presenter.currentQuestion
        presenter.yesButtonClicked()
    }
    
    func buttonIsEnabledFalse() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    private func convert(model: QuizResultsViewModel, action: @escaping (UIAlertAction) -> Void) -> AlertModel {
        return AlertModel(title: model.title, message: model.text, buttonText: model.buttonText, action: action)
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            guard let statisticService = statisticService else {
                print("Сервис статистики не создан")
                return
            }
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
            let bestGame = statisticService.bestGame ?? GameRecord(correct: correctAnswers, total: presenter.questionsAmount, date: Date())
            // показать результат квиза
            let text = "Ваш результат: \(correctAnswers) из \(presenter.questionsAmount)\nКоличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            imageView.layer.borderWidth = 0
            let action: (UIAlertAction) -> Void = { _ in
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0  // скидываем счетчик правильных ответов
                self.questionFactory?.requestNextQuestion()
            }
            alertPresenter?.show(alert: convert(model: viewModel, action: action), identifier: "Final game")
        } else {
            imageView.layer.borderWidth = 0
            // увеличиваем индекс текущего урока на 1, т.о. мы сможем получить следующий урок
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func showAnswerResult(isCorrect: Bool) {
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

