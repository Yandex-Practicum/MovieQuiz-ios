import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    
    
    // MARK: - vars and buttons
    
    
    
    private var currentQuestionIndex = 0
    private var questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    private var countCorrectAnswer = 0
    
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var buttonYes: UIButton!
    
    @IBOutlet private weak var buttonNo: UIButton!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        disableMyButtons()
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        disableMyButtons()
    }
    
    // MARK: - funcs
    
    private func disableMyButtons() {
        buttonNo.isEnabled = false
        buttonYes.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.buttonNo.isEnabled = true
            self.buttonYes.isEnabled = true
        }
        
        
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel (image: UIImage(named: model.image) ?? UIImage(),
                                  question: model.text,
                                  questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        if isCorrect{
            countCorrectAnswer += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            
            
        }
    }
    
    
    private func completion() {
        imageView.layer.cornerRadius = 20
        currentQuestionIndex = 0
        countCorrectAnswer = 0
        questionFactory?.requestNextQuestion()
    }
    private func convertAlertModel(model: QuizResultsViewModel) -> AlertModel {
            return AlertModel(title: model.title,
                              message: model.text,
                              buttonText: model.buttonText,
                              completion: completion)
        }
    private func showAlertResult() {
        guard let gameCount = statisticService?.gamesCount else {return}
        guard let accuracy = statisticService?.totalAccuracy else {return}
        let totalAccuracy = (String(format: "%.2f", accuracy))
       guard let bestGame = statisticService?.bestGame else {return}
        let record = "\(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
        let alertModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                      text: """
                                                       Ваш результат: \(countCorrectAnswer)/10
                                                       Количество завершённых квизов: \(gameCount)
                                                       Рекорд: \(record)
                                                       Средняя точность: \(totalAccuracy)%
                                                       """,
                                                      buttonText: "Сыграть еще раз!")
        let modelResult = convertAlertModel(model: alertModel)
        alertPresenter?.show(quiz: modelResult)
    }
    
    private func showNextQuestionOrResults() {
        guard let GameCount = statisticService?.gamesCount else {return }
        guard let correctAnswer = statisticService?.correctAnswer else {return}
        guard let totalQuestions = statisticService?.totalQuestions else {return}

        var allStatisticsCollected = false
        if currentQuestionIndex == questionsAmount - 1 {
            setNewGameCount(with: GameCount + 1)
            setStoreGameResult(correctAnswersNumber: Int(correctAnswer) + countCorrectAnswer, totalQuestionsNumber: Int(totalQuestions) + questionsAmount)
            setStoreRecord(correct: countCorrectAnswer , total: questionsAmount)
            allStatisticsCollected = true
            if allStatisticsCollected != false {
                showAlertResult()
            }
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    func setStoreRecord(correct count: Int, total amount: Int) {
        statisticService?.storeRecord(correct: count, total: amount)
    }
    
    
    func setNewGameCount(with gameCount: Int) {
        statisticService?.setGameCount(gamesCount: gameCount)
        }
    
    func setStoreGameResult(correctAnswersNumber: Int, totalQuestionsNumber: Int) {
            statisticService?.storeGameResult(correctAnswersNumber: correctAnswersNumber, totalQuestionsNumber: totalQuestionsNumber)
        }
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(controller: self)
        statisticService = StatisticServiceImplementation()
        

        func string(from documentDirectory: URL) throws -> String {
            if !FileManager.default.fileExists(atPath: documentDirectory.path) {
                throw FileManagerError.fileDoesntExist
            }
            return try String(contentsOf: documentDirectory)
        }

        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent("top250MoviesIMDB.json")
        let top250MoviesIMDB = try? string(from: fileURL)
        guard let data = top250MoviesIMDB?.data(using: .utf8) else {return}
        
        do {
            let movie = try JSONDecoder().decode(Movie.self, from: data)
            let result = try? JSONDecoder().decode(Top.self, from: data)
        } catch {
            print("Failed to parse: \(error.localizedDescription)")

        }
        
        
        enum FileManagerError: Error {
            case fileDoesntExist
        }
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
    
    

}




struct Result {
    let answer: Bool
}



