import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    
    // MARK: - Lifecycle
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    
    private var correctAnswers = 0
    private let questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var numberOfGame = 0
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
        
        //MARK: - FIleManager&JSON
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "inception.json"
        documentsURL.appendPathComponent(fileName)
        let jsonString = try? String(contentsOf: documentsURL)
        let data = jsonString?.data(using: .utf8)
        guard let data = data else {return}
        
        struct Actor: Codable {
            let id: String
            let image: String
            let name: String
            let asCharacter: String
        }
        struct Movie: Codable {
            let id: String
            let title: String
            let year: Int
            let image: String
            let releaseDate: String
            let runtimeMins: Int
            let directors: String
            let actorList: [Actor]
            
            enum CodingKeys: CodingKey {
                case id, title, year, image, releaseDate, runtimeMins, directors, actorList
            }
            
            enum ParseError: Error {
                case yearFailure
                case runtimeMinsFailure
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                id = try container.decode(String.self, forKey: .id)
                title = try container.decode(String.self, forKey: .title)
                
                let year = try container.decode(String.self, forKey: .year)
                guard let yearValue = Int(year) else {
                    throw ParseError.yearFailure
                }
                self.year = yearValue
                
                image = try container.decode(String.self, forKey: .image)
                releaseDate = try container.decode(String.self, forKey: .releaseDate)
                
                let runtimeMins = try container.decode(String.self, forKey: .runtimeMins)
                guard let runtimeMinsValue = Int(runtimeMins) else {
                    throw ParseError.runtimeMinsFailure
                }
                self.runtimeMins = runtimeMinsValue
                
                directors = try container.decode(String.self, forKey: .directors)
                actorList = try container.decode([Actor].self, forKey: .actorList)
            }
        }
        do {
            let movie = try JSONDecoder().decode(Movie.self, from: data)
        } catch {
            print("Failed to parse: \(error.localizedDescription)")
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
    
    //MARK: - Private functions
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: { [weak self] in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.imageView.layer.borderWidth = 0
            self.numberOfGame += 1
            self.questionFactory?.requestNextQuestion()
        })
        alertPresenter?.showAlert(model: alertModel)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        switchButton()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }
    
    func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            
            guard let statisticService = statisticService else { return }
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let bestGame = statisticService.bestGame
            let recordGame = "\(bestGame.correct)/\(bestGame.total)"
            let currentDate = bestGame.date.dateTimeString
            let roundingTotalAccuracy = String(format: "%.2f", statisticService.totalAccuracy) + "%"
            
            let text = """
                    Ваш результат: \(correctAnswers)/\(questionsAmount)
                    \n Кол-во сыгранных квизов: \(statisticService.gamesCount)
                    \n Рекорд: \(recordGame) (\(currentDate))
                    \n Средняя точность: \(roundingTotalAccuracy)
            """
            
            let vieModel = QuizResultsViewModel(title: "Раунд окончен!", text: text, buttonText: "Cыграть ещё раз!")
            show(quiz: vieModel)
            switchButton()
        } else {
            imageView.layer.borderWidth = 0
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
            switchButton()
        }
    }
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    private func switchButton()  {
        noButton.isEnabled = !noButton.isEnabled
        yesButton.isEnabled = !yesButton.isEnabled
    }
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let givenAnswer = true
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let givenAnswer = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
}










