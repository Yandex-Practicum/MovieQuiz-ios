import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        currentAlert.delegate = self
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
    private var currentAlert: AlertPresenterProtocol = AlertPresenter()
    
    private var questionFactory: QuestionFactoryProtocol?
    
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    
    private var statisticService: StatisticService?
    
    private var currentQuestion: QuizQuestion?
    
    struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var imageView: UIImageView!
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in // слабая ссылка на self
            guard let self = self else { return } // разворачиваем слабую ссылку
            self.showNextQuestionOrResults()
        }
    }
    
    func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            guard let statisticService = statisticService else {return}
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let text = """
                    Ваш результат: \(correctAnswers)/\(questionsAmount)
                    Количество сыгранных квизов: \(statisticService.gamesCount)
                    Рекорд: \(statisticService.bestGame.correct)/\(questionsAmount) (\(statisticService.bestGame.date.dateTimeString))
                    Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                    """
            let viewModel = AlertModel(
                    title: "Этот раунд окончен!",
                    message: text,
                    buttontext: "Сыграть еще раз!",
                    completion: { [weak self] in
                        guard let self = self else {return}
                        self.currentQuestionIndex = 0
                        self.correctAnswers = 0
                        self.questionFactory?.requestNextQuestion()
                    })
            currentAlert.showAlert(quiz: viewModel)
            } else {
                currentQuestionIndex += 1

                questionFactory?.requestNextQuestion()
            }
        }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
               
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.currentQuestionIndex = 0
            questionFactory?.requestNextQuestion()
            
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false

        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true

        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
