import UIKit
//import CoreData

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Actions
    
    @IBAction private func noButtonTapped(_ sender: UIButton) {
        let answer = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonTapped(_ sender: UIButton) {
        let answer = true
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textlabel: UILabel!
    private var currentQuestionIndex: Int = 0
    
    @IBOutlet private var noButtonOutlet: UIButton!
    
    @IBOutlet private var yesButtonOutlet: UIButton!
    
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol? = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter = AlertPresenter()
    private var statisticService: StatisticService = StatisticServiceImplementation()

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameCount: GameCount = GameCount(countOfGames: statisticService.gamesCount.countOfGames + 1)
        statisticService.gamesCount = gameCount
        imageView.layer.cornerRadius = 20
        questionFactory?.delegate = self
        questionFactory?.requestNextQuestion()
        
        print("SANDBOX ADRESS")
        print(NSHomeDirectory())
        UserDefaults.standard.set(true, forKey: "viewDidLoad")
        
        print("______")
        print("BUNDLE ADRESS")
        print(Bundle.main.bundlePath)
        
        print("______")
        print("АДРЕС ПАПКИ Documents В ПЕСОЧНИЦЕ")
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsURL)
        
        let fileURL = documentsURL.appendingPathComponent("text.swift")
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            let hello = "Hello world!"
            let data = hello.data(using: .utf8)
            FileManager.default.createFile(atPath: fileURL.path, contents: data)
        }
        
        enum FileManagerError: Error {
            case fileDoesntExist
        }
        
        func string(from fileURL: URL) throws -> String {
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                throw FileManagerError.fileDoesntExist
            }
            return try String(contentsOf: fileURL)
        }
        
        let top250MoviesIMDBPath = documentsURL.appendingPathComponent("top250MoviesIMDB")
        let jsonStringTop250MoviesIMDB = try? String(contentsOf: top250MoviesIMDBPath)
        let dataTop250MoviesIMDB = jsonStringTop250MoviesIMDB?.data(using: .utf8)
        guard let dataTop250MoviesIMDB = dataTop250MoviesIMDB else { return }
        var returnedMovieTest: [Movie] = []
        
        do {
            let jsonTop250Movies = try JSONSerialization.jsonObject(with: dataTop250MoviesIMDB, options: []) as? [String: Any]
            guard let jsonTop250Movies = jsonTop250Movies,
                  let items = jsonTop250Movies["items"] as? [[String: String]],
                  let result = try? JSONDecoder().decode(Top.self, from: dataTop250MoviesIMDB) else {
                return
            }
            
            var movieTest: [Movie] = []
            returnedMovieTest = movieTest
            for item in result.items {
                movieTest.append(item)
            }
            
        } catch {
            print("Failed to parse: \(jsonStringTop250MoviesIMDB)")
        }
        
        
    }
    // MARK: - QuestionFactoryDelegate
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Private functions
    
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textlabel.text = step.question
    }
    
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect == true {
            correctAnswers += 1
        }
        noButtonOutlet.isEnabled = false
        yesButtonOutlet.isEnabled = false
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
            self.noButtonOutlet.isEnabled = true
            self.yesButtonOutlet.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        guard currentQuestionIndex == questionsAmount - 1 else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
            imageView.layer.borderWidth = 0
            return
        }
        
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        let bestRecord = statisticService.bestGame
        let totalCount = statisticService.gamesCount.countOfGames
        let totalAccuracy = statisticService.totalAccuracy?.totalAccuracyOfGame
        let totalAccuracyString: String
        if let totalAccuracy = totalAccuracy {
            totalAccuracyString = "Средняя точность: \(Int(totalAccuracy * 100))%"
        } else {
            totalAccuracyString = "Нет статистики"
        }
        
        let text = """
Ваш результат: \(correctAnswers)/\(questionsAmount)\n
Количесчтво сыгранных квизов: \(totalCount)\n
Рекорд: \(bestRecord.correct)/\(bestRecord.total) \(bestRecord.date.dateTimeString)\n
\(totalAccuracyString)
"""
        imageView.layer.borderWidth = 0
        let alertModel: AlertModel = AlertModel(title: "Этот раунд окончен!", message: text, buttonText: "Сыграть ещё раз", completion: { [weak self] in
            guard let self = self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        })
        alertPresenter.present(alert: alertModel, presentingViewController: self)
    }
}

