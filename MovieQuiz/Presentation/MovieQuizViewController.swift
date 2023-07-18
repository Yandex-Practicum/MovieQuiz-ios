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
   
    private var questionFactory: QuestionFactory?  // Фабрика вопросов
    private var alertPresenter: AlertPresenter?  // Презентер для отображения алертов
    private var statisticService: StatisticService?  // Сервис для сохранения статистики
    
     // MARK: - Private Let
    
    private let presenter = MovieQuizPresenter()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewController = self
        presenter.questionFactory = self.questionFactory
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
        presenter.didReceiveNextQuestion(question: question)
    }

    // MARK: - Private functions
    
    // Отображение текущего вопроса
    func showCurrentQuestion(step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    // Отображение результатов квиза
    func showQuizResults(result: QuizResultsViewModel) {
        statisticService?.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)  // Сохранение статистики игры

        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: makeResultMessage(),
            buttonText: result.buttonText) { [weak self] in
                self?.presenter.resetQuestionIndex()
                self?.presenter.correctAnswers = 0
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
        let currentGameResultLine = "Ваш результат: \(presenter.correctAnswers)/\(presenter.questionsAmount)"
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
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            presenter.correctAnswers += 1
        }

        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.correctAnswers = self.presenter.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
        }
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }

    private func showNextQuestionOrResults() {
        presenter.showNextQuestionOrResults()
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
    
    // Обработчик нажатия кнопки "Да"
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
                presenter.yesButtonClicked()
    }

    // Обработчик нажатия кнопки "Нет"
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }

    // Отображение ошибки сети
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }

            self.presenter.resetQuestionIndex()
            self.presenter.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
            self.questionFactory?.loadData()
            showLoadingIndicator()
        }

        alertPresenter?.show(alertModel: model)
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
