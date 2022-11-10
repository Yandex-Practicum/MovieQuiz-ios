import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
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
        
//        let resourceName = "top250MoviesIMDB"
//        let resourceType = "json"
//        let bundle =  Bundle(for: type(of: self))
//        guard let jsonURL = bundle.url(forResource: resourceName, withExtension: resourceType) else { return }
//
//        guard let jsonData = try? Data(contentsOf: jsonURL, options: .mappedIfSafe) else { return }
//
//        let jsonString = try? JSONSerialization.jsonObject(with: jsonData, options: .fragmentsAllowed)
//
//        do {
//            let result = try JSONDecoder().decode(Top.self, from: jsonData)
//        } catch {
//            error.localizedDescription
//        }
        
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
            
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
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
            
            if !isCorrect {
                imageView.layer.borderColor = UIColor.ypRed.cgColor
            } else {
                imageView.layer.borderColor = UIColor.ypGreen.cgColor
                correctAnswers += 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self = self else { return }
                self.showNextQuestionOrResults()
            }
        }
        
        @IBAction private func yesButtonClicked(_ sender: UIButton) {
            guard let currentQuestion = currentQuestion else {return }
            let givenAnswer = true
            
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
        
        @IBAction private func noButtonClicked(_ sender: UIButton) {
            guard let currentQuestion = currentQuestion else {return }
            let givenAnswer = false
            
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    }



//        UserDefaults.standard.set(true, forKey: "viewDidLoad")
//        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//        let jsonName =  "inception.json"
//        documentsURL.appendPathComponent(jsonName)
//        var jsonString: String = ""
//        try? jsonString = (String(contentsOf: documentsURL))
//
//        print(jsonString)
//
//        guard let data = jsonString.data(using: .utf8) else { return }
//
//        do {
//            let movie = try JSONDecoder().decode(Movie.self, from: data)
//
//        } catch {
//            print("Failed to parse: \(error.localizedDescription)")
//        }

//        print(NSHomeDirectory())
//        UserDefaults.standard.set(true, forKey: "viewDidLoad")
//                print(Bundle.main.bundlePath)
//
//        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let fileName =  "text.swift"
//        documentsURL.appendPathComponent(fileName)
//
//        if !FileManager.default.fileExists(atPath: documentsURL.path) {
//            let hello = "Hello world!"
//            let data = hello.data(using: .utf8)
//            FileManager.default.createFile(atPath: documentsURL.path, contents: data)
//        }
//        print(documentsURL.path)
//        try? print(String(contentsOf: documentsURL))
//        //        try? FileManager.default.removeItem(atPath: documentsURL.path)
