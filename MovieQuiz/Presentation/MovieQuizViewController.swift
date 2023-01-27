import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
   
    private var correctAnswers: Int = 0     //счетчик правильных ответов
    private var currentQuestionIndex = 0    //индекс текущего вопроса
    private let questionsAmount: Int = 10
    private var statisticService: StatisticService?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?


//    MARK - Button
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        waitShowNextQuestion(button: sender)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        waitShowNextQuestion(button: sender)
    }
        
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        statisticService = StatisticServiceImplementation()
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter()
        alertPresenter?.delegate = self

        
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
//    MARK - Private functions
    
    //преобразуем данные, которые есть в модели вопроса в те данные,
    //которые необходимо показать
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(named: model.imageName) ?? UIImage()
        let questionNumber = "\(currentQuestionIndex + 1)/\(questionsAmount)"
        let question = model.text
        return QuizStepViewModel(image: image, question: question, questionNumber: questionNumber)
    }
        
    //Заполняем счетчик, картинку, текст вопроса данными. Рамку убираем
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        imageView.layer.borderWidth = 0
    }
    
    
    //функция показывающая правильный/неправильный результат
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.cornerRadius = 20
        if isCorrect {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            
        }
        else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
    }
    
    private func waitShowNextQuestion(button: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
            button.isEnabled = true
        }
    }
    
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == self.questionsAmount - 1 {
            guard let statisticService = statisticService else { return }
            statisticService.store(correct: correctAnswers, total: questionsAmount)

            let totalAccuracyPercentage = String(format: "%.2f", statisticService.totalAccuracy * 100) + "%"
            let localizedTime = statisticService.bestGame.date.dateTimeString
            let bestGameStats = "\(statisticService.bestGame.correct)/\(statisticService.bestGame.total)"

            let text =
            """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(bestGameStats) (\(localizedTime))
            Средняя точность: \(totalAccuracyPercentage)
            """

            let alert = AlertModel(title: "Этот раунд окончен!", message: text, buttonText: "Сыграть еще раз") { [weak self] in
                guard let self = self else { return }

                self.currentQuestionIndex = 0 // сброс счета
                self.correctAnswers = 0

                self.questionFactory?.requestNextQuestion()  // заново показываем первый вопрос
            }


            alertPresenter?.show(result: alert)
        } else {
            currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1
            questionFactory?.requestNextQuestion()
        }
    }

    
}

