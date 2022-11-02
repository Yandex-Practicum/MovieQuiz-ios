import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

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
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20  // закругляю картинку
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(viewController: self)
        statisticService = StatisticServiceImplementation()
        
        enum FileManagerError: Error {
            case fileDoesntExist
        }
        
        struct Items: Codable {
            let items: [Movie]
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
        }
        
        func string(from documentsURL: URL) throws -> String {
            if !FileManager.default.fileExists(atPath: documentsURL.path) {
                throw FileManagerError.fileDoesntExist
            }
            return try String(contentsOf: documentsURL)
        }
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let jsonURL = URL(string: "top250MoviesIMDB.json", relativeTo: documentsURL)
        let decoder = JSONDecoder()
        guard
            let jsonString = try? string(from: jsonURL!),
            let data = jsonString.data(using: .utf8),
            //let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let item = try? decoder.decode(Items.self, from: data)
        else {
            print("Failed to parse")
            return
        }
//        let firstMovie: Movie = item.items[0]
//        print(firstMovie.id)
    }
        
    
    private var currentQuestionIndex: Int = 0
    private var numberOfCorrectAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
   
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText)
            { [weak self] _ in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.numberOfCorrectAnswers = 0
                self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.showAlert(quiz: alertModel)
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")// высчитываем номер вопроса
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect { numberOfCorrectAnswers += 1 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
        }
    }
    
   private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService?.store(correct: numberOfCorrectAnswers, total: questionsAmount) // записываем новые результаты в UserDefaults
            let text = """
                    Ваш результат: \(numberOfCorrectAnswers) из \(questionsAmount)
                    Количество сыгранных квизов: \(statisticService.gamesCount)
                    Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date))
                    Средняя точность: \(Int(statisticService.totalAccuracy))%
                    """
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)// показать результат квиза

        } else {
            currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
            questionFactory?.requestNextQuestion()
        }
    }
}
