import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    // MARK: - IBOutlet

    @IBOutlet private weak var noButton: UIButton!  // Кнопка "Нет"
    @IBOutlet private weak var yesButton: UIButton!  // Кнопка "Да"
    @IBOutlet private weak var imageView: UIImageView!  // Изображение вопроса
    @IBOutlet private weak var textLabel: UILabel!  // Текст вопроса
    @IBOutlet private weak var counterLabel: UILabel!  // Счетчик текущего вопроса
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!  // Индикатор загрузки

    // MARK: - Private variables
   
    private var correctAnswers = 0  // Количество правильных ответов
    private var questionFactory: QuestionFactory?  // Фабрика вопросов
    private var currentQuestion: QuizQuestion?  // Текущий вопрос
    private var alertPresenter: AlertPresenter?  // Презентер для отображения алертов
    private var statisticService: StatisticService?  // Сервис для сохранения статистики
    
     // MARK: - Private Let
    
    private let presenter = MovieQuziPresenter()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        statisticService = StatisticServiceImpl(userDefaults: UserDefaults.standard)  // Инициализация сервиса статистики
        alertPresenter = AlertPresenterImpl(viewController: self)  // Инициализация презентера алертов
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)  // Инициализация фабрики вопросов
        questionFactory?.loadData()  // Загрузка данных вопросов
        showLoadingIndicator()  // Показ индикатора загрузки
        activityIndicator.hidesWhenStopped = true  // Скрытие индикатора загрузки при остановке
        activityIndicator.startAnimating()  // Запуск анимации индикатора загрузки
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent  // Установка стиля статус-бара
    }

    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }

    // MARK: - Private functions
    
    // Отображение текущего вопроса
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    // Отображение результатов квиза
    private func show(quize result: QuizResultsViewModel) {
        statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)  // Сохранение статистики игры

        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: makeResultMessage(),
            buttonText: result.buttonText) { [weak self] in
                self?.presenter.resetQuestionIndex()
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
        alertPresenter?.show(alertModel: alertModel)  // Отображение алерта с результатами
    }

    // Генерация текста сообщения с результатами
    private func makeResultMessage() -> String {
        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
            assertionFailure("error message")
            return ""
        }

        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(accuracy)%"

        let components: [String] =
        [currentGameResultLine,
         totalPlaysCountLine,
         bestGameInfoLine,
         averageAccuracyLine]

        let resultMessage = components.joined(separator: "\n")
        return resultMessage
    }

    // Отображение результата ответа на вопрос
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }

        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            self.imageView.layer.borderWidth = 0
        }
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }

    // Переход к следующему вопросу или отображение результатов квиза
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            let text = correctAnswers == presenter.questionsAmount ?
            "Поздравляем, Вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз"
            )
            show(quize: viewModel)
        } else {
            presenter.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
        }
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }

    // Показ индикатора загрузки
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    // Скрытие индикатора загрузки
    private func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }

    // Отображение ошибки сети
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }

            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
            self.questionFactory?.loadData()
            showLoadingIndicator()
        }

        alertPresenter?.show(alertModel: model)
    }

    // Обработчик нажатия кнопки "Да"
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true

        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    // Обработчик нажатия кнопки "Нет"
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false

        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    // Обработка ошибки загрузки данных
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }

    // Завершение загрузки данных
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
}
