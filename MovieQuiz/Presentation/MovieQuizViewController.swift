import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {

    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBOutlet private weak var textLabel: UILabel!
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService?
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel { //подготавливаю структуру перед выводом
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }

    private func show(quiz step: QuizStepViewModel) {   // Показываю вопрос на экране
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }
    
    // MARK: - showNextQuestionOrResults
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
        guard let statisticService = statisticService else { return }
        statisticService.store(correct: correctAnswers, total: questionsAmount)

        let totalAccuracyPercentage = String(format: "%.2f", statisticService.totalAccuracy * 100) + "%"
        let localTime = statisticService.bestGame.date.dateTimeString
        let bestGameStats = "\(statisticService.bestGame.correct)/\(statisticService.bestGame.total)"
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message:"""
                        Ваш результат: \(correctAnswers)/\(questionsAmount)
                        Количество сыгранных квизов: \(statisticService.gamesCount)
                        Рекорд: \(bestGameStats) (\(localTime))
                        Средняя точность: \(totalAccuracyPercentage)
                    """,
            buttonText: "Сыграть ещё раз",
            completion: { [weak self] in
            guard let self = self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion() // заново показываем первый вопрос
        })
        alertPresenter = AlerPresenter(delegate: self)
        alertPresenter?.showAlert(result: alertModel) // вызвать Алерт
      } else {
        currentQuestionIndex += 1
        questionFactory?.requestNextQuestion()
      }
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    override func viewDidLoad() { //Показал стартовый вопрос
        super.viewDidLoad()
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
    }
}

