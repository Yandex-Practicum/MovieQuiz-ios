import UIKit

final class MovieQuizViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var noButton: UIButton!  // Кнопка "Нет"
    @IBOutlet private weak var yesButton: UIButton!  // Кнопка "Да"
    @IBOutlet private weak var imageView: UIImageView!  // Изображение вопроса
    @IBOutlet private weak var textLabel: UILabel!  // Текст вопроса
    @IBOutlet private weak var counterLabel: UILabel!  // Счетчик текущего вопроса
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!  // Индикатор загрузки

    // MARK: - Private variables
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenter?  // Презентер для отображения алертов
    private var statisticService: StatisticService?  // Сервис для сохранения статистики

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        statisticService = StatisticServiceImpl(userDefaults: UserDefaults.standard)  // Инициализация сервиса статистики
        alertPresenter = AlertPresenterImpl(viewController: self)  // Инициализация презентера алертов
        showLoadingIndicator()  // Показ индикатора загрузки
        activityIndicator.hidesWhenStopped = true  // Скрытие индикатора загрузки при остановке
        activityIndicator.startAnimating()  // Запуск анимации индикатора загрузки
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent  // Установка стиля статус-бара
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
                self?.presenter.restartGame()
                self?.presenter.correctAnswers = 0
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
            self.presenter.showNextQuestionOrResults()
        }
    }

    // Показ индикатора загрузки
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    // Скрытие индикатора загрузки
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
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
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }

            self.presenter.restartGame()
            self.presenter.correctAnswers = 0
            showLoadingIndicator()
        }

        alertPresenter?.show(alertModel: model)
    }
}
