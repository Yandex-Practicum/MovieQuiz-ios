import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresentProtocol {
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenterDelegate: AlertPresenterDelegate?
    private var statisticServiceImplementation: StatisticServiceImplementation?
    
    // MARK: - Lifecycle
    override  func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenterDelegate = AlertPresenter(startOverDelegate: self)
        imageView.layer.cornerRadius = 20
        statisticServiceImplementation = StatisticServiceImplementation()
    }
    // MARK: - QuestionFactoryDelegate
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        print(question.text)
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func startOver() {
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        self.questionFactory?.requestNextQuestion()
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        self.imageView.image = step.image
        self.counterLabel.text = step.questionNumber
        self.textLabel.text = step.question
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        guard let statisticServiceImplementation = statisticServiceImplementation else { return }
        self.statisticServiceImplementation?.store(correct: correctAnswers, total: questionsAmount)
        self.statisticServiceImplementation?.gamesQuizCount += 1
        self.statisticServiceImplementation?.correctAnswersAllTheTime += correctAnswers
        self.statisticServiceImplementation?.questionsAllTheTime += questionsAmount
        self.statisticServiceImplementation?.totalAccuracy = Double(statisticServiceImplementation.correctAnswersAllTheTime) / Double(statisticServiceImplementation.questionsAllTheTime) * 100
    // MARK: - AlertModel
    let alertModel = AlertModel(title: result.title,
                                    masseg: """
                                    Ваш результат: \(correctAnswers)/\(questionsAmount)
                                    Количеств сыгранных квизов: \(statisticServiceImplementation.gamesQuizCount)
                                    Рекорд: \(statisticServiceImplementation.bestGame.correct)/\(questionsAmount) (\(statisticServiceImplementation.bestGame.date.dateTimeString))
                                    Средняя точность: \(String(format:"%.2f",statisticServiceImplementation.totalAccuracy))%
                                    """,
                                    buttonText: result.buttonText)
        
        
        
       guard let alertPresenterDelegate = alertPresenterDelegate else {return}
        present(alertPresenterDelegate.showAlert(alertModel: alertModel), animated: true)
 
    }


    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // высчитываем номер вопроса
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
                correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.YPGreen.cgColor : UIColor.YPRed.cgColor
        imageView.layer.cornerRadius = 20
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in// запускаем задачу через 1 секунду
            // код, который вы хотите вызвать через 1 секунду,
            guard let self = self else {return}
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
        }
    }
    
    private func showNextQuestionOrResults() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
        if currentQuestionIndex == questionsAmount - 1 {
            let text = "Ваш результат: \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    // MARK: Buttons YES and NO
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
}
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
}
    
}

