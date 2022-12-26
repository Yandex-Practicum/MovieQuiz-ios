import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    
    private var questionFactory: QuestionFactoryProtocol?
    
    private var alert: AlertPresenterProtocol?
    
    private var statisticService: StatisticService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        
        alert = AlertPresenter(controller: self)
        
        statisticService = StatisticServiceImplementation()
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
    }

    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
                    return
        }
        currentQuestion = question
        showQuestion(question: question)
    }
   
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true, button: sender)
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false, button: sender)
    }
    
    private func showQuestion(question: QuizQuestion) {
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = viewModel.image
            self?.textLabel.text = viewModel.question
            self?.counterLabel.text = viewModel.questionNumber
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
       return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showAnswerResult(isCorrect: Bool, button actionButton: UIButton) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
            
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            self.imageView.layer.borderColor = nil
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            
            guard let gamesCount = statisticService?.gamesCount else {return}
            guard let bestGame = statisticService?.bestGame else {return}
            guard let totalAccuracy = statisticService?.totalAccuracy else {return}

            let message = "Ваш результат: \(correctAnswers)/\(questionsAmount)\n Количество сыгранных квизов: \(gamesCount)\n Рекорд: \(bestGame.correct)/\(bestGame.total) \(bestGame.date.dateTimeString) \n Средняя точность: \(String(format: "%.2f", totalAccuracy))%"
            let alertModel = AlertModel(
                            title: "Этот раунд окончен!",
                            message: message,
                            buttonText: "Сыграть еще раз",
                            completion: {
                                self.currentQuestionIndex = 0
                                self.correctAnswers = 0
                                self.questionFactory?.requestNextQuestion()
                            })
            alert?.showAlert(result: alertModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
}
