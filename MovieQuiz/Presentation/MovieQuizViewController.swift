import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Private var
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmout = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(alertVC: self, delegate: self)
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        statisticService = StatisticServiceImplementation()
    }
    
    //MARK: - QuestionFactoryDelegate
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quizStep: viewModel)
        }
    }
    
    //MARK: - AlertPresenterDelegate
    func didShowAlert() {
        restartQuiz()
    }
    
    //MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let answerToQuestion = false
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: answerToQuestion == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let answerToQuestion = true
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: answerToQuestion == currentQuestion.correctAnswer)
    }
    
    //MARK: - Methods
    private func show(quizStep: QuizStepViewModel) {
        imageView.image = quizStep.image
        textLabel.text = quizStep.question
        counterLabel.text = quizStep.questionNumber
    }
    
    private func restartQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmout)"
        )
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        
        if currentQuestionIndex == questionsAmout - 1 {
            
            let text = statisticService?.store(correct: correctAnswers, total: questionsAmout)
            let viewModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text ?? "nil",
                buttonText: "Сыграть еще раз?",
                completion: nil)
            alertPresenter?.showAlert(model: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let viewModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: nil)
        
            alertPresenter?.showAlert(model: viewModel)
            }
       
    }

