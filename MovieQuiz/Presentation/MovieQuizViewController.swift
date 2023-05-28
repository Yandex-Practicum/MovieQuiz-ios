import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var upperLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var previewImage: UIImageView!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter: AlertPresenterProtocol?
    
    private var statisticService: StatisticServiceProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        counterLabelUISetup()
        upperLabelUIsetup()
        previewImageUISetup()
        questionLabelUISetup()
        yesButtonUISetup()
        noButtonUISetup()
        
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        
        alertPresenter = AlertPresenter(delegate: self)
        
        statisticService = StatisticService()
        
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert (model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - UI Setup
    
    private func counterLabelUISetup () {
        counterLabel.text = "\(currentQuestionIndex)/10"
        counterLabel.textColor = .ypWhite
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
    }
    
    private func upperLabelUIsetup () {
        upperLabel.text = "Вопрос:"
        upperLabel.textColor = .ypWhite
        upperLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
    }
    
    private func previewImageUISetup () {
        previewImage.backgroundColor = .ypWhite
        previewImage.layer.masksToBounds = true
        previewImage.layer.cornerRadius = 20
        previewImage.layer.borderWidth = 8
        previewImage.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func questionLabelUISetup () {
        questionLabel.numberOfLines = 2
        questionLabel.textAlignment = .center
        questionLabel.textColor = .ypWhite
        questionLabel.font = UIFont (name: "YSDisplay-Bold", size: 23)
    }
    
    private func yesButtonUISetup () {
        yesButton.layer.cornerRadius = 15
        yesButton.layer.masksToBounds = true
        yesButton.backgroundColor = .ypWhite
        yesButton.setTitle("Да", for: .normal)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.setTitleColor(.ypBlack, for: .normal)
    }
    
    private func noButtonUISetup () {
        noButton.layer.cornerRadius = 15
        noButton.layer.masksToBounds = true
        noButton.backgroundColor = .ypWhite
        noButton.setTitle("Нет", for: .normal)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.setTitleColor(.ypBlack, for: .normal)
    }
    
    // MARK: - Private Functions
    
    private func convert (model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                             question: model.text,
                                             questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show (quiz step: QuizStepViewModel) {
      previewImage.image = step.image
      questionLabel.text = step.question
      counterLabel.text = step.questionNumber
    }
    
    private func showAlert () {
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        
        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else { return }
        
        let resultMessage =
    """
    Ваш результат: \(correctAnswers)\\\(questionsAmount)
    Количество сыгранных квизов: \(statisticService.gamesCount)
    Рекорд: \(bestGame.correct)\\\(bestGame.total) \(bestGame.date.dateTimeString)
    Средняя точность: \(String (format: "%.2f", statisticService.totalAccuracy))%
    """
        
        let alertModel = AlertModel (title: "Этот раунд окончен!", message: resultMessage, buttonText: "Сыграть ещё раз", completion: { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion() })
        
        alertPresenter?.show(quiz: alertModel)
    }
    
    private func showAnswerResult (isCorrect: Bool) {
        previewImage.layer.borderWidth = 8
        
        if isCorrect {
            previewImage.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
            print ("Дан правильный ответ.")
        } else {
            previewImage.layer.borderColor = UIColor.ypRed.cgColor
            print ("Дан неверный ответ.")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in guard let self = self else { return }
            self.showNextQuestionOrResult()
        }
    }
    
    private func showNextQuestionOrResult () {
        previewImage.layer.borderColor = UIColor.clear.cgColor
        yesButton.isEnabled = true
        noButton.isEnabled = true
        
        if currentQuestionIndex == questionsAmount - 1 {
            showAlert()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
        print ("Нажата кнопка - Да.")
        
        yesButton.isEnabled = false
        
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
        print ("Нажата кнопка - Нет.")
        
        noButton.isEnabled = false
    }
    
}
