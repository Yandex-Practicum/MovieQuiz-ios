import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate, RoundDelegate {

    // связь объектов из main-экрана с контроллером
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    private let alertPresenter = AlertPresenter()
    private var currentRound: Round?
    private var statisticService: StatisticService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // настраиваем внешний вид рамки
        setupImageView()
        alertPresenter.delegate = self
        // стартуем новый раунд
        startNewRound()
    }
    
    // MARK: Настройка внешнего вида
    
    // приватный метод визуализации рамки
    private func setupImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
    }
    
    // приватный метод отключения/включения кнопок
    private func setAnswerButtonsEnabled(_ enabled: Bool) {
        noButton.isEnabled = enabled
        yesButton.isEnabled = enabled
    }
    
    // MARK: Обработка логики
    
    // метод отвечающий за старт нового раунда квиза
    private func startNewRound() {
        setAnswerButtonsEnabled(true)
        currentRound = Round()
        currentRound?.delegate = self
        currentRound?.requestNextQuestion()
    }
    
    // делаем если вопрос был получен
    func didReceiveNewQuestion(_ question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        // показываем вопрос
        showQuestion(quiz: convert(model: question))
        // включаем кнопки
        setAnswerButtonsEnabled(true)
    }
    
    // делаем если раунд был закончен
    func roundDidEnd(_ round: Round, withResult gameRecord: GameRecord) {
        statisticService = StatisticServiceImplementation()
        showQuizResults()
    }
    
    // делаем если алерт был показан
    func alertDidDismiss() {
        startNewRound()
    }
        
    private func showQuizResults() {
        let model1 = statisticService
        let alertModel1 = convert1(model: model1)
        alertPresenter.present(alertModel: alertModel1, on: self)
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func showQuestion(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    // визуализация рамки
    private func showQuestionAnswerResult(isCorrect: Bool) {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        })
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        setAnswerButtonsEnabled(false)
        let isCorrect = currentRound?.checkAnswer(checkTap: false) ?? false
        showQuestionAnswerResult(isCorrect: isCorrect)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        setAnswerButtonsEnabled(false)
        let isCorrect = currentRound?.checkAnswer(checkTap: true) ?? false
        showQuestionAnswerResult(isCorrect: isCorrect)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionNumber = currentRound?.getNumberCurrentQuestion() ?? 0
        let totalQuestions = currentRound?.getCountQuestions() ?? 0
        let displayNumber = questionNumber + 1

        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(displayNumber) / \(totalQuestions)"
        )
    }
    
    private func convert1(model: StatisticService?) -> AlertModel {
        guard let bestGame = model?.bestGame else {
            return AlertModel(title: "Ошибка", message: "Данные не доступны!", buttonText: "ОК")
        }
        
        let gamesCount = model?.gamesCount ?? 0
        let gamesAccuracy = model?.totalAccuracy ?? 0.0

        let correctAnswers = currentRound?.getCorrectCountAnswer() ?? 0
        let totalQuestions = currentRound?.getCountQuestions() ?? 0

        let recordCorrect = bestGame.correct
        let recordTotal = bestGame.total
        let recordDate = bestGame.date
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: """
            Ваш результат: \(correctAnswers) / \(totalQuestions)
            Количество сыгранных квизов: \(gamesCount)
            Рекорд: \(recordCorrect) / \(recordTotal) (\(recordDate.dateTimeString))
            Средняя точность: \(gamesAccuracy)%
            """,
            buttonText: "Сыграть еще раз"
        )
        
        return alertModel
    }

    // MARK: сервисные методы
    // посмотреть все записи
    fileprivate func printAllUserDefaults() {
        let userDefaults = UserDefaults.standard
        print("All UserDefaults:")
        for (key, value) in userDefaults.dictionaryRepresentation() {
            print("\(key) = \(value)")
        }
    }
    
    // удалить все в UserDeafult
    fileprivate func remove() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
