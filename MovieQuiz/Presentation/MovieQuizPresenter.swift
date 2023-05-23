import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {

    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewController?
    private let statisticService: StatisticService!

    private var currentQuestion: QuizQuestion?
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0

    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        statisticService = StatisticServiceImplemintation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }


    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }

    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }

    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }

    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }

    func yesButtonClicked() {
        didAnswer(isYes: true)
    }

    func noButtonClicked() {
        didAnswer(isYes: false)
    }

    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        showNetworkError(message: message)
    }

    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }

    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }

    private func showNextQuestionOrResults() {
        if isLastQuestion() {
            var text = "Ваш результат \(correctAnswers)/\(questionsAmount)"
            if let statisticService = statisticService {
                statisticService.store(correct: correctAnswers, total: questionsAmount)
                text += """
                        \nКоличество сыгранных квизов: \(statisticService.gamesCount)
                        Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                        Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                        """
            }

            let viewModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] _ in
                    guard let self = self else { return }
                    self.resetQuestionIndex()
                    self.correctAnswers = 0
                    self.questionFactory?.requestNextQuestion()
                })
            showAlert(viewModel)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }

    func showAlert(_ alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Game result"
        let action = UIAlertAction(
            title:alertModel.buttonText,
            style: .default,
            handler: alertModel.completion)
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }

    private func proceedWithAnswer(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.viewController?.view.isUserInteractionEnabled = true
            self.showNextQuestionOrResults()
        }
        viewController?.view.isUserInteractionEnabled = false
    }

    func showNetworkError(message: String) {
        viewController?.hideLoadingIndicator()

        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать ещё раз") { [weak self] _ in
            guard let self = self else { return }

            self.questionFactory?.loadData()
            self.restartGame()
        }
        showAlert(model)
    }

}

