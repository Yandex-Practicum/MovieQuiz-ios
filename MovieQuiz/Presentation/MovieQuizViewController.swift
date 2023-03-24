import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let nextQuestion = question else { return }
        currentQuestion = nextQuestion
        let viewModel = convert(model: nextQuestion)
        show(quiz: viewModel)
    }
    @IBOutlet private var questionTitleLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private lazy var questionFactory: QuestionFactoryProtocol = QuestionFactory(delegate: self)
    private var currentQuestion: QuizQuestion?
    var statisticService: StatisticService!
    var alertPresenter: AlertPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let firstQuestion = questionFactory.requestNextQuestion() {
            currentQuestion = firstQuestion
            let viewModel = convert(model: firstQuestion)
            show(quiz: viewModel)
            noButton.titleLabel?.font =  UIFont(name: "YSDisplay-Medium", size: 20)
            yesButton.titleLabel?.font =  UIFont(name: "YSDisplay-Medium", size: 20)
            textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
            counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
            questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
            yesButton.isEnabled = true
            noButton.isEnabled = true
            statisticService = StatisticServiceImplementation()
            alertPresenter = AlertPresenter(viewController: self)
        }
    }
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        yesButton.isEnabled = false
        noButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    private func show(quiz result: QuizResultsViewModel) {
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy * 100)
        let gamesCount = statisticService.gamesCount
        let message = """
        Ваш результат: \(correctAnswers) из 10
        Количество сыгранных квизов: \(gamesCount)
        Рекорд: \(statisticService.bestGame.correct) из 10 (\(statisticService.bestGame.date.dateTimeString))
        Средняя точность: \(accuracy)%
        """
        let alertModel = AlertModel(
            title: result.title,
            message: message,
            buttonText: result.buttonText) { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                if let firstQuestion = self.questionFactory.requestNextQuestion() {
                    self.currentQuestion = firstQuestion
                    let viewModel = self.convert(model: firstQuestion)
                    self.show(quiz: viewModel)
                }
            }
        alertPresenter.showAlert(alertModel: alertModel)
    }
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let text = "Ваш результат: \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
            yesButton.isEnabled = true
            noButton.isEnabled = true
        } else {
            currentQuestionIndex += 1
            yesButton.isEnabled = false
            noButton.isEnabled = false
            if let nextQuestion = questionFactory.requestNextQuestion() {
                currentQuestion = nextQuestion
                let viewModel = convert(model: nextQuestion)
                show(quiz: viewModel)
            }
            yesButton.isEnabled = true
            noButton.isEnabled = true
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
