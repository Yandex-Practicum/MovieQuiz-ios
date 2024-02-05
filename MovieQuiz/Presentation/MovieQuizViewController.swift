import UIKit
import Foundation


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
        
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var alertPresenter: AlertPresenterProtocol = AlertPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20.0
        noButton.isEnabled = true
        yesButton.isEnabled = true
        
        questionFactory.delegate = self
        questionFactory.requestNextQuestion()
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
    
    @IBAction private func noButtonTapped(_ sender: UIButton){   // NO BUTTON
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        noButton.isEnabled = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonTapped(_ sender: UIButton){    // YES BUTTON
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        yesButton.isEnabled = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.Black.cgColor
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.Green.cgColor : UIColor.Red.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз?")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            
            imageView.layer.borderColor = UIColor.White.cgColor
            self.questionFactory.requestNextQuestion()
            
            noButton.isEnabled = true
            yesButton.isEnabled = true
        }
    }
    
    private func show(quiz result: QuizResultViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            buttonAction: { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory.requestNextQuestion()
            }
        )
        alertPresenter?.show(alertModel: alertModel)
    }
    
    func show(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
}
