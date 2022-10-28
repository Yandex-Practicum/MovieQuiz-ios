import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
            guard let currentQuestion = currentQuestion else { return }
            let givenAnswer = true
            
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
            guard let currentQuestion = currentQuestion else { return }
            let givenAnswer = false
            
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Private functions
    private func showAlert(){
        guard let alertPresenter = alertPresenter else { return }
        alertPresenter.showAlert()
    }
    
    private func show(quiz step: QuizStepViewModel) {
        guard let currentQuestion = currentQuestion else { return }
        
        counterLabel.text = convert(model: currentQuestion).questionNumber
        textLabel.text = convert(model: currentQuestion).question
        imageView.image = convert(model: currentQuestion).image
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            imageView.layer.borderWidth = 0
            
            guard let statisticService = statisticService else {
                return
            }
            
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            
            let text = """
Ваш результат: \(correctAnswers) из \(questionsAmount)
Количество сыгранных квизов: \(statisticService.gamesCount)
Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy as CVarArg))%
"""
            
            alertPresenter = AlertPresenter(modelToShowAlert:
                                                AlertModel.init(
                                                    title: "Этот раунд окончен!",
                                                    message: text,
                                                    buttonText: "Сыграть ещё раз",
                                                    completion: {
                                                        self.currentQuestionIndex = 0
                                                        self.correctAnswers = 0
                                                        self.questionFactory?.requestNextQuestion()
                                                    }))
            
            alertPresenter?.viewController = self
            showAlert()
        } else {
            currentQuestionIndex += 1
            imageView.layer.borderWidth = 0
            questionFactory?.requestNextQuestion()
        }
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
        
        DispatchQueue.main.asyncAfter (deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
}
