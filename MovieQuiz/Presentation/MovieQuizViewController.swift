import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var questionFactory: QuestionFactory?
    private var currentQuestion: QuizQuestion?
    private let questionsCount = 10
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    //MARK:- Actions
    
    @IBAction private func noButtonCliked(_ sender: Any) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        answerGiven (givenAnswer: false)
        
    }
    @IBAction private func yesButtonCliked(_ sender: Any) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        answerGiven (givenAnswer: true)
      
    }
    
    //MARK:- Private functions
    
    private func answerGiven (givenAnswer: Bool) {
        _ = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: givenAnswer == currentQuestion?.correctAnswer)
       
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsCount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
        
      
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self]
            in guard let self = self else {return}
            self.showNextQuestionOrResults()
            
        }
    }
    
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questionsCount - 1 {
            
          showFinalResults()
            noButton.isEnabled = true
            yesButton.isEnabled = true
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
            noButton.isEnabled = true
            yesButton.isEnabled = true
        }
    }
    
    private func showFinalResults () {
        statisticService?.store(correct: correctAnswers, total: questionsCount)
        
      
        
        let alertModel = AlertModel(
            title: "Игра Окончена",
            message: makeResultMessage(),
            buttonText: "Ok",
            buttonAction:{ [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                
                self?.questionFactory?.requestNextQuestion()
            }
                )
        
        alertPresenter?.show(alertModel: alertModel)
    }
    
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        questionFactory = QuestionFactoryImpl(delegate: self)
        alertPresenter = AlertPresenterImpl(viewController: self)
        
        statisticService = StatisticServiceImpl()
        
        imageView.layer.cornerRadius = 20
        questionFactory?.requestNextQuestion()
    }
    private func makeResultMessage() -> String {
         
        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
            assertionFailure("Erroe message")
            return ""
        }
        
        let totalPlaysCountLine = "Количество сыграннх квизов\(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат \(correctAnswers)\\\(questionsCount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)" + "(\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMessage = [
            totalPlaysCountLine, currentGameResultLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMessage
    }
}

extension MovieQuizViewController: QuestionFactoryDelegate {
    
    func didReceiveQuestion (_ question: QuizQuestion) {
        self.currentQuestion = question
        let viewModel = self.convert(model: question)
        self.show(quiz: viewModel)
    }
}
    

