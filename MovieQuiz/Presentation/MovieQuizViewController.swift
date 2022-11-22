//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Konstantin Zuykov on 07.11.2022.
//

import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    private var alertPresenter: AlertPresenter?
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService?
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
        questionFactory?.loadData()
        
        currentQuestionIndex = 0
        correctAnswers = 0
        
        yesButtonOutlet.isEnabled = true
        noButtonOutlet.isEnabled = true
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var noButtonOutlet: UIButton!
    @IBOutlet weak var yesButtonOutlet: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        yesButtonOutlet.isEnabled = false
        showAnswerResult(isCorrect: true == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        noButtonOutlet.isEnabled = false
        showAnswerResult(isCorrect: false == currentQuestion.correctAnswer)
    }
    
    // MARK: - Delegates
    
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
        showNetworkErrorAlert(message: error.localizedDescription)
    }
    
    // MARK: - Alerts
    
    private func showNetworkErrorAlert(message: String) {
        hideLoadingIndicator()
        let errorAlertModel = AlertModel(title: "Ошибка",
                                         message: message,
                                         buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            self.restartGame()
        }
        
        alertPresenter?.show(controller: self, model: errorAlertModel)
    }
    
    private func showEndGameAlert() {
        if let statisticService = statisticService {
            // store current play result
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            // show alert message
            let bestGame = statisticService.bestGame
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.YYYY HH:mm"
            
            let alertTitle = "Этот раунд окончен!"
            let alertButtonText = "Сыграть ещё раз"
            let alertText = """
            Ваш результат: \(correctAnswers) из 10
            Количество сыграных квизов: \(statisticService.gamesCount)
            Рекорд: \(bestGame.correct)/\(bestGame.total) (\(dateFormatter.string(from: bestGame.date)))
            Средняя точность: (\(String(format: "%.2f", statisticService.totalAccuracy))%)
            """
            let resultsAlertModel = AlertModel(title: alertTitle, message: alertText, buttonText: alertButtonText) { [weak self] in
                guard let self = self else { return }
                self.restartGame()
            }
            alertPresenter?.show(controller: self, model: resultsAlertModel)
        }
    }

    // MARK: - Private functions
    
    private func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func getAppColor(_ name: String) -> CGColor {
        if let color = UIColor(named: name) {
            return color.cgColor
        } else {
            return UIColor.white.cgColor
        }
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? getAppColor("ypGreen") : getAppColor("ypRed")
        
        if isCorrect {
            correctAnswers += 1
        }
        
        showLoadingIndicator()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.hideLoadingIndicator()
            self.yesButtonOutlet.isEnabled = true
            self.noButtonOutlet.isEnabled = true
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            // All questions are shown
            showEndGameAlert()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
        
    }
}
