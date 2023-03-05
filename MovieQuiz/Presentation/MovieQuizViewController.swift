import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet var noButton: UIButton!
    @IBOutlet var yesButton: UIButton!
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var statisticService: StatisticService?
    private var alertPresenter: AlertPresenter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter()
        statisticService = StatisticServiceImplementation() 
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
                image: UIImage(named: model.image) ?? UIImage(),
                question: model.text,
                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        }
        
            private func showAnswerResult(isCorrect: Bool) {
                
                if isCorrect {
                    correctAnswers += 1
                }
                imageView.layer.masksToBounds = true
                imageView.layer.borderWidth = 8
                imageView.layer.cornerRadius = 20
                imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    guard let self = self else { return }
                    
                    self.imageView.layer.borderWidth = 0
                    self.showNextQuestionOrResults()
                }
            }
    
            
            private func showNextQuestionOrResults() {
                
                if currentQuestionIndex == questionsAmount - 1 {
                    statisticService?.store(correct: correctAnswers, total: questionsAmount)
                    
                    guard let gamesCount = statisticService?.gamesCount else { return }
                    guard let totalAccuracy = statisticService?.totalAccuracy else { return }
                    guard let bestGame = statisticService?.bestGame else { return }

                                 let text =
                    "Ваш результат: \(correctAnswers)/\(questionsAmount)\n Количество сыгранных квизов: \(gamesCount)\n Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))\n Средняя точность: \(String(format: "%.2f", totalAccuracy))%"
                   
                    let alertPresenter = AlertPresenter()
                    
                    let alertModel = AlertModel(
                                     title: "Этот раунд окончен!",
                                     message: text,
                                     buttonText: "Сыграть ещё раз")
                                 { [weak self] _ in
                                     guard let self = self else { return }

                                     self.currentQuestionIndex = 0
                                     self.correctAnswers = 0
                                     self.questionFactory?.requestNextQuestion()
                                 }

                                 alertPresenter.showAlert(with: alertModel, in: self )
                } else {
                    currentQuestionIndex += 1
                    questionFactory?.requestNextQuestion()
                    }
                }
                
                
            }
    

