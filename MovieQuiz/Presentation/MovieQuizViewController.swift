import UIKit



final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        
        questionFactory?.requestNextQuestion()
    }
    //MARK: QuestionFactoryDalagate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        } }
    @IBAction private func yesButtonClick(_ sender: Any) {
        noButton.isEnabled = false
        yesBotton.isEnabled = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    @IBAction private func noButtonClick(_ sender: Any) {
        noButton.isEnabled = false
        yesBotton.isEnabled = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private weak var yesBotton: UIButton!
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var quizPlayed = 0
    private var quizRecord = 0
    private var dateRecord: String = ""
    private var avarageAccuracy: Double = 0
    private var allCorrectAnswers = 0
    private var allAnswers = 0
    
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        correctAnswers = isCorrect ? correctAnswers + 1 : correctAnswers
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            // код, который мы хотим вызвать через 1 секунду
            
            self.imageView.layer.masksToBounds = false
            self.imageView.layer.borderWidth = 0
            self.imageView.layer.borderColor = nil
            self.noButton.isEnabled = true
            self.yesBotton.isEnabled = true
            self.showNextQuestionOrResults()
        }
    }
    
    // вью модель для состояния "Вопрос показан"
    
    // для состояния "Результат квиза"
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        questionFactory?.requestNextQuestion()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        textLabel.textAlignment = .center
    }
    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            allCorrectAnswers += correctAnswers
            allAnswers += questionsAmount
            avarageAccuracy = Double(allCorrectAnswers) / Double(allAnswers) * 100
            quizPlayed += 1
            if correctAnswers > quizRecord {
                quizRecord = correctAnswers
                _ = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yy HH:mm:ss"
                dateRecord = dateFormatter.string(from: Date())
            }
            let text = "Ваш результат: \(correctAnswers)/10" // 1
            let viewModel = QuizResultsViewModel( // 2
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel) // 3
        } else { // 2
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion() } }
        private func show(quiz result: QuizResultsViewModel) {
            let alert = UIAlertController(
                title: "Этот раунд окончен!",
                message: "Ваш результат \(correctAnswers)/10 \nКоличество сыгранных квизов: \(quizPlayed) \nРекорд: \(quizRecord)/\(questionsAmount) (\(dateRecord)) \nСредняя точность: \(String(format: "%.2f", avarageAccuracy))%",
                preferredStyle: .alert)
            
            let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                questionFactory?.requestNextQuestion()
                }
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil) }
        
        
    }


// массив вопросов
