// swiftlint:disable all

import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    private let presenter = MovieQuizPresenter()
    private var questionFactory: QuestionFactoryProtocol?
//    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
//    private var currentQuestionCounter: Int = 0
    private let moviesLoader = MoviesLoader()
        
    // Statistic
    private var statisticService = StatisticServiceImplementation()
    private var correctAnswersCounter = 0
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        processUserAnswer(answer: false)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        processUserAnswer(answer: true)
    }
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
        
        questionFactory = QuestionFactory(delegate: self, moviesLoader: moviesLoader)
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageBorderDefaultStyle() // Настройка стиля обводки ImageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    // QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        hideLoadingIndicator()
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
            self?.hideLoadingIndicator()
        }
    }
    
    // MARK: - NETWORK
    
    private func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        let alert = AlertPresenter(
            title: "Сетевая ошибка",
            text: message,
            buttonText: "Продолжить",
            controller: self,
            accessibilityIdentifier: "error_alert",
            onAction: { _ in
                self.showLoadingIndicator()
                self.questionFactory?.loadData()
            }
        )
        DispatchQueue.main.async {
            self.hideLoadingIndicator()
            alert.showAlert()
        }
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // сообщение об ошибке
    }
    
    // MARK: - QUIZ STEP
    
    // Вывод данных на экран
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = UIImage(data: step.image)
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // MARK: - QUIZ RESULT
    
    // Вывод данных на экран
    private func show(quiz result: QuizResultViewModel) {
        
        let alert = AlertPresenter(
            title: result.title,
            text: result.text,
            buttonText: result.buttonText,
            controller: self,
            accessibilityIdentifier: "shown_alert",
            onAction: { _ in
                self.correctAnswersCounter = 0
                self.presenter.resetQuestionIndex()
                self.showLoadingIndicator()
                self.questionFactory?.requestNextQuestion()
            }
        )
    
        DispatchQueue.main.async {
            alert.showAlert()
        }
    }
    
    // MARK: - ANSWER RESULT
    
    // Вывод на экран рамки для фото в зависимости от правильности
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            imageBorderColor(for: "correct")
            
        } else {
            imageBorderColor(for: "incorrect")
        }
    }
    
    
    // MARK: - QUIZ BRAIN
    
    // Определяю правильность ответа
    private func processUserAnswer(answer: Bool) {
        
        if let currentQuestion = currentQuestion {
            if answer == currentQuestion.correctAnswer {
                showAnswerResult(isCorrect: true)
                correctAnswersCounter += 1 // Записал успешный результат
            } else {
                showAnswerResult(isCorrect: false)
            }
            buttonsEnabled(is: false) // временно отключил кнопки
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.imageBorderDefaultStyle()
                self.showNextQuestionOrResults()
                self.buttonsEnabled(is: true) // включил кнопки
            }
        }
        
    }
    
    // Показываем следующий вопрос или результат всей викторины
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() { // это последний вопрос
            statisticService.store(correct: correctAnswersCounter, total: presenter.questionsAmount) // Проверил на рекорд
            if correctAnswersCounter == presenter.questionsAmount {
                // Статистика для победителя - X из X правильных ответов
                let winResult = QuizResultViewModel(
                    title: "Вы выиграли!",
                    text:
                    """
                    Ваш результат: \(correctAnswersCounter)/\(presenter.questionsAmount)
                    Количество сыгранных квизов: \(statisticService.gamesCount)
                    Рекорд: \(statisticService.bestGame.correct) /\(presenter.questionsAmount) (\(statisticService.bestGame.date.dateTimeString))
                    Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))
                    """,
                    buttonText: "Сыграть еще раз"
                )
                show(quiz: winResult)
            } else {
                // Статистика
                let result = QuizResultViewModel(
                    title: "Этот раунд окончен!",
                    text:
                    """
                    Ваш результат: \(correctAnswersCounter)/\(presenter.questionsAmount)
                    Количество сыгранных квизов: \(statisticService.gamesCount)
                    Рекорд: \(statisticService.bestGame.correct) /\(presenter.questionsAmount) (\(statisticService.bestGame.date.dateTimeString))
                    Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                    """,
                    buttonText: "Сыграть еще раз"
                )
                show(quiz: result)
            }
        } else { // это не последний вопрос
            presenter.switchToNextQuestion()
            showLoadingIndicator()
            questionFactory?.requestNextQuestion()
        }
    }
    
    // Делаю кнопки "да" и "нет" активными или нет по необходимости
    private func buttonsEnabled(is state: Bool) {
        yesButton.isEnabled = state
        noButton.isEnabled = state
    }
    
}


// MARK: - CLASS EXTENSIONS

// НАСТРОЙКА СТИЛЕЙ ОБВОДКИ ИМИДЖА
extension MovieQuizViewController {
    
    // Дефолтные стили обводки UIView
    private func imageBorderDefaultStyle() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageBorderColor(for: "default")
    }
    
    // Изменение цвета обводки в зависимости от правильности ответа
    private func imageBorderColor(for state: String) {
        switch state {
        case "correct":
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        case "incorrect":
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        default:
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
}
