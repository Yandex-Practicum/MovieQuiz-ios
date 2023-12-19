import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: Outlets
    
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textView: UILabel!
    @IBOutlet private weak var counterView: UILabel!
    
    // MARK: Properties
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private lazy var statisticService: StatisticServiceProtocol = StatisticServiceImplementation()
    
    // MARK: Overrides funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenterImpl(viewController: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return.lightContent
    }
    
    // MARK: Func
    
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
    
    // MARK: Private funcs
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textView.text = step.question
        counterView.text = step.questionNumber
    }
    
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        self.yesButton.isEnabled = false
        self.noButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            self.showNextQuestionOrResults()
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    private func showAlert(quizResult quiz: QuizResultsViewModel) {
        
        let alertModel = AlertModel(title: quiz.title,
                                    text: quiz.text,
                                    buttonText: quiz.buttonText,
                                    buttonAction: {[weak self] in
            self?.currentQuestionIndex = 0
            self?.correctAnswers = 0
            self?.questionFactory?.requestNextQuestion()
        })
        alertPresenter?.show(AlertModel: alertModel)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            showAlert(quizResult: QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: """
                Ваш результат: \(correctAnswers)/10
                Количество сыгранных квизов: \(statisticService.gamesCount)
                Рекорд: \(statisticService.bestGame.toString())
                Средняя точность: \(Int(statisticService.totalAccuracy))%
                """,
                buttonText: "Сыграть еще раз"))
            questionFactory = QuestionFactory(delegate: self)
            questionFactory?.requestNextQuestion()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
}
