import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterProtocol {
    
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    private var currentQuestionIndex: Int = 0
    private var currentGame = GameRecord(correct: 0, total: 10, date: Date())
    private var statisticService: StatisticService = StatisticServiceImplementation()
    private var totalCorrect: Int = 0
    private var totalQuestions: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.questionShuffle()
        questionFactory?.requestNextQuestion()
        
        //  здесь был код с парсером джсона, но я его пока удалила, не обращайте внимания, комментарий, чтобы не забыть
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
    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: Any) {
        answerIs(answer: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        answerIs(answer: true)
    }
    
    // MARK: - Private functions
    private func answerIs(answer: Bool) {
        showAnswerResult(isCorrect: answer == currentQuestion?.correctAnswer)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == currentGame.total - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
            statisticService.gamesCount += 1 // счетчик сыгранных игр
            totalCorrect += currentGame.correct // сколько всего за все игры правильных ответов
            totalQuestions += currentGame.total // сколько всего за все игры вопросов
            statisticService.totalAccuracy = Double(totalCorrect*100/totalQuestions) // считаем общую точность
            statisticService.store(correct: currentGame.correct, total: currentGame.total) // сравниваем рекорд с текущей игрой
            show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!", text: "Ваш результат: \(currentGame.correct) из \(currentGame.total)\nКоличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(statisticService.bestGame.date.dateTimeString)\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%", buttonText: "Сыграть еще раз"))
            questionFactory?.resetIndex()
        } else {
            currentQuestionIndex += 1 // увеличиваем индекс текущего вопроса на 1; таким образом мы сможем получить следующий вопрос
            // показать следующий вопрос
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // делаем рамку цветной
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
            self?.imageView.layer.borderColor = UIColor.clear.cgColor
            self?.yesButton.isEnabled = true
            self?.noButton.isEnabled = true
        }
        if isCorrect { currentGame.correct += 1 }
        
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        counterLabel.text = step.questionNumber
        questionLabel.text = step.question
        imageView.image = step.image
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            self.currentGame.correct = 0
            self.currentQuestionIndex = 0
            guard let currentQuestion = self.currentQuestion else {
                return
            }
            self.show(quiz: self.convert(model: currentQuestion))
            self.questionFactory?.questionShuffle()
            self.questionFactory?.requestNextQuestion()
        }
        
        showAlert(alertModel: alertModel)
        
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(currentGame.total)")
        
    }
    
}
