import UIKit

/*
Здравствуйте, Александра. Я планирую после вашего финального ревью взять академ, не только из-за
проблем со временем, но и из-за постоянных исправлений учебника по ходу обучения первой кагорты.
 
5 спринт выдался очень сложным, принёс очень много разочарования и растерянности, а также сомнений,
 надо ли мне вообще это. Его я выполнял с помощью ребят с кагорты, самостоятельно в такие сроки не
 выполнил бы.
 
 Хочу у вас попросить помощи, если вам будет несложно ответить, я понимаю, что это не в зоне вашх
 обязанностей, поэтому я пойму, если не станете отвечать, я ценю ваше время. У меня два вопроса.
 Что можно делать в ситуации сильной демотивации, когда всё не получается и очень тяжело всё
 понять и осознать? А так же, что вы посоветуете поизучать во время академа, чтобы вернуться с пониманием
 этого материала? Учебник мне не помогает, всё объяснено непонятно, на сложных примерах, запутанно
 и так далее. Я буду вам очень благодарен за совет..
 
 На счёт цвета, я не понимаю, в чём проблема. Цвет Background в сториборде #1A1B22 с 60% alpha,
 как в макете фигмы.. :/
 Плюс в прошлый раз всё было нормально, а я ничего в цвете не менял. Может дело в названии? Сменил.
*/

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate  {
    
    
    // MARK: - Lifecycle

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService = StatisticServiceImplementation()
    
    @IBOutlet private weak var buttonNo: UIButton!
    @IBOutlet private weak var buttonYes: UIButton!
    
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
        
        print(NSHomeDirectory())
        print(Bundle.main.bundlePath)
    
        UserDefaults.standard.set(true, forKey: "viewDidLoad")
        
        alertPresenter = AlertPresenter(delegate: self)
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
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
    
    // MARK: - AlertPresenterDelegate
    
    func didShowAlert(controller: UIAlertController?) {
            guard let controller = controller else {
                return
            }
            present(controller, animated: true, completion: nil)
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
            
            if statisticService.gamesCount >= 0 {
                statisticService.gamesCount += 1
            }
            
            let record = GameRecord(correct: correctAnswers, total: questionsAmount, date: Date().dateTimeString)
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let isBestRecord = GameRecord.isBest(current: record, previous: statisticService.bestGame)

            if isBestRecord {
                statisticService.bestGame = record
            }
            
            let text = "Ваш результат: \(correctAnswers) из \(questionsAmount)\nКоличество сыграных квизов: \(statisticService.gamesCount)\nРекорд:  \(statisticService.bestGame.correct)/\(questionsAmount) \(statisticService.bestGame.date)\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy as CVarArg))%"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
            show(quiz: viewModel) // show result
            } else {
                currentQuestionIndex += 1
                imageView.layer.borderWidth = 0
                questionFactory?.requestNextQuestion()
            }

    }

    
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = "\(step.questionNumber)"
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: {
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        })
        alertPresenter?.showAlert(model: alertModel)

    }
}
