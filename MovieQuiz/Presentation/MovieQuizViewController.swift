import UIKit





final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    //MARK: - Properties
    // Аутлеты для текста, счётчика, изображения и кнопок
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    // Переменная индекса текущего вопроса в MovieQuizViewController
    private var currentQuestionIndex: Int = 0
    // Переменная для подсчёта колличества верных ответов
    private var correctAnswers: Int = 0
    // Общее колличество вопросов
    private let questionsAmount: Int = 10
    // Экземпляр фабрики вопросов
    private var questionsFactory: QuestionFactoryProtocol?
    // Текущий вопрос, который видит пользователь
    private var currentQuestion: QuizQuestion?
    // Экземпляр AlertPresenter для отображения Алерта
    private let alertPresenter = AlertPresenter()
    //
    private var statisticService: StatisticServiceImplementation = .init()
    //
    enum CodingKeys: String, CodingKey {
       case id, title, year, image, runtimeMins, directors, actorList
       case releaseDate = "release_date"
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsFactory = QuestionFactory(delegate: self)
        questionsFactory?.requestNextQuestion()
    }
    //MARK: - QuestionFactoryDelegate
    func didReciveNextQuestion (question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    //MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    //MARK: - Helpers
    //Функция блокировки переключения активности кнопок. Используется в showAnswerResult
    private func toggleIsEnablebButtons(){
        noButton.isEnabled.toggle()
        yesButton.isEnabled.toggle()
    }
    
    // Функция для создания первой вью модели
    private func startGame(question: [QuizQuestion]?){
        guard let questions = question else{
            return
        }
        let viewModel = convert(model: questions[0])
        show(quiz: viewModel)
    }
    
    // функция для передачи в вью модель необходимых данных
    private func show(quiz step: QuizStepViewModel) {
        self.imageView.image = step.image
        self.textLabel.text = step.question
        self.counterLabel.text = step.questionNumber
    }
    
    //Функция для вызова алерта с результатами раунда
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText
        ) { [weak self] in
            guard let self = self else { return }
           // restart
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            // заново показываем первый вопрос
            self.questionsFactory?.requestNextQuestion()
        }
        alertPresenter.show(in: self, model: alertModel)
    }
    
    //Функция преобразования вопроса в вью модель
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: String("\(currentQuestionIndex + 1)/\(questionsAmount)")
        )
    }
    
    //Функция для отображения рамки с цветовой индикацией правильности ответа и блокировки кнопок на времяпоказа рамки с последующей разблокировкой и убиранием рамки
    private func showAnswerResult(isCorrect: Bool){
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [ weak self ] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            self.toggleIsEnablebButtons()
        }
        toggleIsEnablebButtons()
    }
    
    //функция выбора действия: показ результата раунда, если вопрос последний или следующего вопроса
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.gamesCount += 1
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let bestGameText = "\(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))"
            let text = "Ваш результат: \(correctAnswers)/\(questionsAmount)\nКолличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(bestGameText)\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен",
                text: text,
                buttonText: "Сыграть ещё раз")
            self.show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            questionsFactory?.requestNextQuestion()
        }
    }
}
//

