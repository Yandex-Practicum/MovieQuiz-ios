import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate/*, AlertPresenterDelegate*/ {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        var documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "top250MoviesIMDB.json"
        documentURL.appendPathComponent(fileName)
        
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
            let rank: String
            let title: String
            let fullTitle: String
            let year: String
            let image: String
            let crew: String
            let imDbRating: String
            let imDbRatingCount: String
            
            enum CodingKeys: CodingKey {
                case id, rank, title, fullTitle, year, image, crew, imDbRating, imDbRatingCount
            }
            
            enum ParseError: Error {
                case yearFailure
                case runtimeMinsFailure
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                id = try container.decode(String.self, forKey: .id)
                rank = try container.decode(String.self, forKey: .rank)
                title = try container.decode(String.self, forKey: .title)
                fullTitle = try container.decode(String.self, forKey: .fullTitle)
                year = try container.decode(String.self, forKey: .year)
                image = try container.decode(String.self, forKey: .image)
                crew = try container.decode(String.self, forKey: .crew)
                imDbRating = try container.decode(String.self, forKey: .imDbRating)
                imDbRatingCount = try container.decode(String.self, forKey: .imDbRatingCount)
            }
        }
        
        func getMovie(from jsonString: String) -> Top? {
            let data = jsonString.data(using: .utf8)!
            let result = try? JSONDecoder().decode(Top.self, from: data)
            return result
        }
        
        
        
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        
        questionFactory.delegate = self
        alertPresenter.delegate = self

        
        showLoadingIndicator()
        questionFactory.loadData()
    }
    
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService = StatisticServiceImplementation()
    private var alertPresenter: AlertPresenter = AlertPresenter()
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory(moviesLoader: MoviesLoader())
    
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
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
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - AlertPresenterDelegate
    
//    var viewController: UIViewController {
//        self
//    }
    
    // MARK: - Private functions
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        print(step.image)
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
            //self.questionFactory.requestNextQuestion()
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            //let text = correctAnswers == questionsAmount ? "Поздравляем, Вы ответили на 10 из 10!" : "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let text = "Ваш результат: \(correctAnswers)/\(questionsAmount)\n Количество сыграных квизов: \(statisticService.gamesCount)\n Рекорд: \(statisticService.bestGame.correctAnswers)/\(statisticService.bestGame.totalAnswers) (\(statisticService.bestGame.date.dateTimeString))\n Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            let viewModel = AlertModel(title: "Этот раунд окончен!", message: text, buttonText: "Сыграть ещё раз") { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory.requestNextQuestion()
            }
            
            alertPresenter.show(quiz: viewModel)
            
        } else {
            currentQuestionIndex += 1
            self.questionFactory.loadData()
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let viewModel = AlertModel(title: "Ошибка!", message: message, buttonText: "Попробовать ещё раз") { [weak self] in
            guard let self = self else { return }
            self.showLoadingIndicator()
            self.questionFactory.loadData()
        }
        alertPresenter.show(quiz: viewModel)
    }
}
