
import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    //MARK: - IBOutlet

    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    // MARK: - Private Properties
    
    private var currentQuestion: QuizQuestion?
    private var questionsFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    private let questionsAmount = 10
    private var currentQuestionsIndex = 0
    private var score = 0

    // MARK: - Lifecyclequestions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsFactory = QuestionFactory(delegate: self)
        questionsFactory?.requestQuestion()
        alertPresenter = AlertPresenter(viewController: self)
        statisticService = StatisticServiceImplementation()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convertToQuizStepViewModel(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let answer = false
        guard let currentQuestion = currentQuestion else { return  }
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
        lockButtonClick(isEnable: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let answer = true
        guard let currentQuestion = currentQuestion else { return  }
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
        lockButtonClick(isEnable: false)
    }
}

// MARK: - Logic MovieQuizViewController
extension MovieQuizViewController {
    
    // MARK: - Private Methods
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.image = step.image
    }
    
    private func convertToQuizStepViewModel(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: ("\(currentQuestionsIndex + 1) / \(questionsAmount)"))
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            imageView.layer.borderColor = UIColor.YPGreen?.cgColor
            score += 1
        } else {
            imageView.layer.borderColor = UIColor.YPRed?.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            self.lockButtonClick(isEnable: true)
        }
    }
    
    private func lockButtonClick(isEnable: Bool) {
        noButton.isEnabled = isEnable
        yesButton.isEnabled = isEnable
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionsIndex == questionsAmount - 1 {
            statisticService?.store(correct: self.score, total: self.questionsAmount)
            guard  let gameCount = statisticService?.gamesCount,
                  let bestGame = statisticService?.bestGame,
                  let totalAccuracy = statisticService?.totalAccuracy  else { return  }
            
            let messangeAlert = """
              \(Constatns.AlertLable.scoreRound) \(score)/\(questionsAmount) \n
              \(Constatns.AlertLable.numberOfQuizzesPlayed) \(gameCount) \n
              \(Constatns.AlertLable.bestScore) \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))\n
              \(Constatns.AlertLable.avgAccuracy) \(totalAccuracy)%
              """

            let alertModel = AlertModel(title: Constatns.AlertLable.title, messange: messangeAlert, buttonText: Constatns.AlertButton.buttonText) { [weak self] in
                guard let self = self else { return }
                self.resetScore()
            }
            showAlert(quiz: alertModel)
            
        } else {
            currentQuestionsIndex += 1
            questionsFactory?.requestQuestion()
        }
    }
    
    private func resetScore() {
        currentQuestionsIndex = 0
        score = 0
        questionsFactory?.requestQuestion()
    }
}

// MARK: - Show Alert MovieQuizViewController

extension MovieQuizViewController: ShowAlertDelegate {
    func showAlert(quiz result: AlertModel?) {
        guard let result = result else { return }
        alertPresenter?.creationAlert(data: result)
    }
}
