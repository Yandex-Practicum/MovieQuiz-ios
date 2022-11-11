import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(viewController: self)
        statisticService = StatisticServiceImplementation()
    }
    
    struct Top: Decodable {
        let items: [Movie]
    }
    
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
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            title = try container.decode(String.self, forKey: .title)
            
            let year = try container.decode(String.self, forKey: .year)
            self.year = Int(year)!
            
            image = try container.decode(String.self, forKey: .image)
            releaseDate = try container.decode(String.self, forKey: .releaseDate)
            
            let runtimeMins = try container.decode(String.self, forKey: .runtimeMins)
            self.runtimeMins = Int(runtimeMins)!
            
            directors = try container.decode(String.self, forKey: .directors)
            actorList = try container.decode([Actor].self, forKey: .actorList)
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
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.cornerRadius = 20
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            guard let statisticService = statisticService else { return }
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: """
                            Ваш результат: \(correctAnswers) из 10
                            Количество сыгранных квизов: \(statisticService.gamesCount)
                            Рекорд: \(statisticService.bestGame.correct) (\(statisticService.bestGame.date.dateTimeString))
                            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                            """,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] _ in
                    guard let self = self else { return }
                    self.questionFactory?.requestNextQuestion()
                })
            alertPresenter?.show(model: alertModel)
            currentQuestionIndex = 0
            correctAnswers = 0
            imageView.layer.borderWidth = 0
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            guard let self = self else { return }
            self.noButton.isEnabled = false
            self.yesButton.isEnabled = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return }
        
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return }
        
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
}
