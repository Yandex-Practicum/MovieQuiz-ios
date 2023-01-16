import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    // MARK: - Lifecycle
    
    
    
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var countLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var answer: Bool = true
    private var statisticService: StatisticService?
    
    private enum FileManagerError: Error {
             case fileDoesntExist
         }

    private enum ParseError: Error {
             case yearFailure
             case runtimeMinsFailure
         }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        
        alertPresenter = AlertPresenter()
        alertPresenter?.controller = self
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader())
        questionFactory?.delegate = self
        questionFactory?.requestNextQuestion()
        statisticService = StatisticServiceImplementation()
        
        questionFactory?.loadData()
        showLoadingIndicatior()
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
    
    // MARK: - AlertPresenterDelegate
    
    func didPresentAlert(alert: UIAlertController?) {
        guard let alert = alert else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor(named: "YP Green")?.cgColor : UIColor(named: "YP Red")?.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
            
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        countLabel.text = step.questionNumber
        imageView.image = step.image
        questionLabel.text = step.question
    }
    
    private func showNextQuestionOrResults() {
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        
        if currentQuestionIndex == questionsAmount - 1 {
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        guard let gamesCount = statisticService?.gamesCount else {return}
        guard let bestGame = statisticService?.bestGame else {return}
        guard let totalAccuracy = statisticService?.totalAccuracy else {return}
            
            alertPresenter = AlertPresenter()
            alertPresenter?.controller = self
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: """
                Ваш результат: \(correctAnswers)/\(questionsAmount)
                Количество сыгранных квизов: \(gamesCount)
                Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
                Средняя точность: \(String(format: "%.2f", totalAccuracy))%
                """,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] _ in
                    guard let self = self else { return }
                    self.correctAnswers = 0
                    self.currentQuestionIndex = 0
                    self.questionFactory?.requestNextQuestion()
                })
            
            alertPresenter?.show(alert: alertModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        
    }
    
    private func showLoadingIndicatior() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
            hideLoadingIndicator()
            
            let alertError = UIAlertController(
                title: "Что-то пошло не так(",
                message: message,
                preferredStyle: .alert)
            let action = UIAlertAction(title: "Попробовать еще раз?",
                                       style: .default) { _ in


                self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader())

                self.questionFactory?.delegate = self

                self.statisticService = StatisticServiceImplementation()

                self.questionFactory?.loadData()

                self.showLoadingIndicatior()

            }
            alertError.addAction(action)
            self.present(alertError, animated: true, completion: nil)
        }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    
    
}
