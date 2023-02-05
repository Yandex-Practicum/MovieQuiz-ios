import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswer: Int = 0
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        showLoadingIndicator()
    }
   // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    func didLoadDataFromServer() {
       hideLoadingIndicator()
       questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    
    // MARK: - Action
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = true
        showAnswerResult(isCorrect: currentQuestion.correctAnswer )
        
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = false
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer )
    }
    
    // MARK: - Private functions

    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        alertPresenter = AlertPresenter(modelToShowAlert:
                                            AlertModel.init(
                                                title: "Ошибка",
                                                message: message,
                                                buttonText: "Попробовать еще раз",
                                                completion: {
                                                    self.showLoadingIndicator()
                                                    self.questionFactory?.loadData()
                                                    self.questionFactory?.requestNextQuestion()
                                                }))
        
        alertPresenter?.viewController = self
        showAlert()
        
    }
    
    private func show(quiz step: QuizStepViewModel) {
        guard let currentQuestion = currentQuestion else { return }
        
        imageView.image = convert(model: currentQuestion).image
        textLabel.text = convert(model: currentQuestion).question
        counterLabel.text = convert(model: currentQuestion).questionNumber
    }
    
    private func showAlert() {
        guard let alertPresenter = alertPresenter else { return }
        alertPresenter.showAlert()
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
 
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswer += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
    
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            imageView.layer.borderWidth = 0
            
            guard let statisticService = statisticService else {
                return
            }
            
            statisticService.store(correct: correctAnswer, total: questionsAmount)
            
            
            let text = """
Ваш результат: \(correctAnswer) из \(questionsAmount)
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
                                                        self.correctAnswer = 0
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
}
