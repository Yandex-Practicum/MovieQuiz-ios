import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var alertPresenter : AlertPresenter?
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol? = nil
    private var statisticService: StatisticService?
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var YesButton: UIButton!
    
    @IBAction private func yesButtonClicked(_ sender: Any)
    {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func noButtonClicked(_ sender: Any)
    {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }        
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        alertPresenter = AlertPresenter(viewController: self)
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        statisticService = StatisticServiceImplementation()
    }
    private func showNextQuestionOrResults(){
        if currentQuestionIndex == questionsAmount - 1{
            statisticService?.store(correct: self.correctAnswers, total: self.questionsAmount)
            guard  let gameCount = statisticService?.gamesCount,
                   let bestGame = statisticService?.bestGame,
                   let totalAccuracy = statisticService?.totalAccuracy
            else {
                return
            }
            let messageResult = """
                Вы результат: \(correctAnswers)/\(questionsAmount)
                Количество сыгранных квизов: \(gameCount)
                Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
                Средняя точность: \(totalAccuracy)%
                """
            let viewModel = AlertModel(title: "Этот раунд окончен!",
                                       message: messageResult,
                                       buttonText: "Сыграть ещё раз",
                                       completion: { [weak self] _ in
                                               self?.currentQuestionIndex = 0
                                               self?.correctAnswers = 0
                                               self?.questionFactory?.requestNextQuestion()
                                            }
                                        )
            self.alertPresenter?.show(result: viewModel)
        }
            else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    private func show(quiz step: QuizStepViewModel) {
        self.imageView.image = step.image
        self.textLabel.text = step.question
        self.counterLabel.text = step.questionNumber
    }
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        if isCorrect == true {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers = correctAnswers + 1
        }
        else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        self.YesButton.isEnabled = false
        self.noButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.YesButton.isEnabled = true
            self.noButton.isEnabled = true
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }
}

