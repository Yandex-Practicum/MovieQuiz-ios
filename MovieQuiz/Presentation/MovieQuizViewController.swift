import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private let questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    @IBOutlet weak var buttonNo: UIButton!
    @IBOutlet weak var buttonYes: UIButton!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        buttonNo.isEnabled = false
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        let giveAnswer = false
        showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        buttonYes.isEnabled = false
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        let giveAnswer = true
        showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let firstQuestion = questionFactory.requestNextQuestion() {
            currentQuestion = firstQuestion // каждый сгенерированный вопрос мы должны сохранять в свойство currentQuestion
            let viewModel = convert(model: firstQuestion)
            show(quiz: viewModel)
        }
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
        //imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        buttonNo.isEnabled = true
        buttonYes.isEnabled = true
        if currentQuestionIndex == questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ?
                    "Поздравляем, Вы ответили на 10 из 10!" :
                    "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let viewModel = QuizResultsViewModel(
                  title: "Этот раунд окончен!",
                  text: text,
                  buttonText: "Сыграть ещё раз")
            imageView.layer.borderWidth = 0
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            imageView.layer.borderWidth = 0
            if let nextQuestion = questionFactory.requestNextQuestion() {
                currentQuestion = nextQuestion
                let viewModel = convert(model: nextQuestion)
                
                show(quiz: viewModel)
            }
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = "\(step.questionNumber)"
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        // здесь мы показываем результат прохождения квиза
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            if let firstQuestion = self.questionFactory.requestNextQuestion() {
                self.currentQuestion = firstQuestion
                let viewModel = self.convert(model: firstQuestion)
                
                self.show(quiz: viewModel)
            }
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}

//Рамка картинки
/*
imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
imageView.layer.borderWidth = 1 // толщина рамки
imageView.layer.borderColor = UIColor.white.cgColor // делаем рамку белой
imageView.layer.cornerRadius = 6 // радиус скругления углов рамки
*/

/*
private func convert(model: QuizQuestion) -> QuizStepViewModel {
    return QuizStepViewModel(
        image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
        question: model.text, // берём текст вопроса
        questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // высчитываем номер вопроса
 }*/
