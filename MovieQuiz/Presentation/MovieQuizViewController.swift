import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate {
    
    // связь объектов из main-экрана с контроллером
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    private let alertPresenter = AlertPresenter()
    // переменная с текущим раундом
    private var currentRound: Round?
    private var statistics: StatisticServiceImplementation?
    
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
    
    // MARK: - QuestionFactoryDelegate

    // метод отвечающий за старт нового раунда квиза
    private func startNewRound() {
        setAnswerButtonsEnabled(true)
        currentRound = Round(numberOfQuestions: 10)
        showNextQuestion()
    }
    
    private func showNextQuestion() {
        guard let question = currentRound?.getCurrentQuestion() else {
            if let currentGameRecord = currentRound?.getGameRecord() {
                StatisticServiceImplementationRound(currentGame: currentGameRecord).store()
                statistics = StatisticServiceImplementation()
            }
            
            showQuizResults()
            return
        }

        let viewModel = convert(model: question)
        show(quiz: viewModel)
        setAnswerButtonsEnabled(true)
    }
    
    private func showQuizResults() {
        let model1 = statistics
        let alertModel1 = convert1(model: model1)
        alertPresenter.present(alertModel: alertModel1, on: self)
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func alertDidDismiss() {
        startNewRound()
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestion()
        }
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        setAnswerButtonsEnabled(false)
        let isCorrect = currentRound?.checkAnswer(checkTap: false) ?? false
        showAnswerResult(isCorrect: isCorrect)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        setAnswerButtonsEnabled(false)
        let isCorrect = currentRound?.checkAnswer(checkTap: true) ?? false
        showAnswerResult(isCorrect: isCorrect)
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
    
    private func convert1(model: StatisticServiceImplementation?) -> AlertModel {
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
