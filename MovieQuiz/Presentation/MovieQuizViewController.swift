import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    //Outlets
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    
    private var currentQuestionIndex: Int = 0
    
    
    private var correctAnswers: Int = 0
    private let questionsAmount = 10
    private let questionFactory = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory.delegate = self
        questionFactory.requestNextQuestion()
        didReceiveNextQuestion(question: currentQuestion)
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
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // делаем рамку зеленой или красной
        togglenteraction() //отключаем кнопки и затемняем
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.togglenteraction() //включаем кнопки и ставим альфу 1
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            
        }
        
    }
    private func togglenteraction() {
        self.noButton.isEnabled.toggle() //отключаем кнопки чтобы нельзя было выбирать во время задержки
        self.yesButton.isEnabled.toggle()
        self.yesButton.alpha = yesButton.isEnabled ? 1.0 : 0.8
        self.noButton.alpha = noButton.isEnabled ? 1.0 : 0.8
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        
    }
    private func show(quiz result: QuizResultsViewModel) {
        // создаём объекты всплывающего окна
        
        let alert = UIAlertController(title: result.title, // заголовок всплывающего окна
                                      message: result.text, // текст во всплывающем окне
                                      preferredStyle: .alert)
        
        // создаём для него кнопки с действиями
        let action = UIAlertAction(title: result.buttonText, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            //заново показываем первый вопрос
            self.questionFactory.requestNextQuestion()
            
        })
        
        // добавляем в алерт кнопки
        alert.addAction(action)
        
        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == self.questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, Вы ответили на \(questionsAmount) из \(questionsAmount)!" :
            "Вы ответили на \(correctAnswers) из \(questionsAmount), попробуйте ещё раз!"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                 text: text,
                                                 buttonText: "Сыграть еще раз")
            show(quiz: viewModel)
        } else {
            self.currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1
            questionFactory.requestNextQuestion()
        }
    }
    
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(named: model.image) ?? UIImage()
        let question = model.text
        let questionNumber = "\(currentQuestionIndex + 1)/\(questionsAmount)"
        //currentQuestionIndex += 1
        return QuizStepViewModel(image: image, question: question, questionNumber: questionNumber)
    }
    
}






