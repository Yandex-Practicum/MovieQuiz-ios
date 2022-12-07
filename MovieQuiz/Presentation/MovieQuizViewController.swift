import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    private var currentQuestionIndex: Int = 0
    
    private var correctAnswer: Int = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        statisticService = StatisticServiceImplementation()
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
    // MARK: - Private functions
    private func showAlert(){
        guard let alertPresenter = alertPresenter else { return }
        alertPresenter.showAlert()
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswer += 1
        }
        // indicates the correctness of the answer, the width of the sides, shows a red or green frame
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        yesButton.isEnabled = false
        noButton.isEnabled = false

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    private func showNextQuestionOrResults() {
      if currentQuestionIndex == questionsAmount - 1 {
          
          guard let statisticService = statisticService else { return }
          statisticService.store(correct: correctAnswer, total: questionsAmount)
          
          let text = """
Ваш результат: \(correctAnswer) из \(questionsAmount)
Количество сыгранных квизов: \(statisticService.gamesCount)
Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
"""
          
          alertPresenter = AlertPresenter(modelShowAlert: AlertModel.init(title: "Этот раунд окончен!", message: text, buttonText: "Сыграть еще раз", completion: {self.currentQuestionIndex = 0
              self.correctAnswer = 0
              self.questionFactory?.requestNextQuestion()
          }))
          alertPresenter?.viewController = self
          showAlert()
          imageView.layer.borderColor = nil
          imageView.layer.borderWidth = 0
      } else {
        currentQuestionIndex += 1
        // when switching to the next question, remove the frame and color
        imageView.layer.borderColor = nil
        imageView.layer.borderWidth = 0
          questionFactory?.requestNextQuestion()
      }
    }
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer )
        
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer )
    }
}
