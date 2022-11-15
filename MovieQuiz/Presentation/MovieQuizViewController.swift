import UIKit



final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Lifecycle
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    private var correctAnswers: Int = 0
    
    private var currentQuestionIndex: Int = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter: AlertPresenterProtocol?
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        // преобразовываем данные модели вопроса в те, что нужно показать на экране
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        
        questionFactory?.requestNextQuestion()
        
        // здесь мы показываем результат прохождения квиза
        let alert = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            guard let currentQuestion = self.currentQuestion else { return }
            let firstQuestionModel = self.convert(model: currentQuestion)
            self.show(quiz: firstQuestionModel)
        }
        alertPresenter?.present(model: alert)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(viewController: self)
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let inceptionPath = documentsURL.appendingPathComponent("inception.json")
        let jsonString = try? String(contentsOf: inceptionPath)
        let data = jsonString?.data(using: .utf8)
        guard let data = data else { return }

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
        }

        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            guard let json = json,
                  let id = json["id"] as? String,
                  let title = json["title"] as? String,
                  let jsonYear = json["year"] as? String,
                  let year = Int(jsonYear),
                  let image = json["image"] as? String,
                  let releaseDate = json["releaseData"] as? String,
                  let jsonRuntimeMins = json["runtimeMins"] as? String,
                  let runtimeMins = Int(jsonRuntimeMins),
                  let directors = json["directors"] as? String,
                  let actorList = json["actorList"] as? [Any] else {
                return
            }
            var actors: [Actor] = []

            for actor in actorList {
                guard let actor = actor as? [String: Any],
                      let id = actor["id"] as? String,
                      let image = actor["image"] as? String,
                      let name = actor["name"] as? String,
                      let asCharacter = actor["asCharacter"] as? String else {
                    return
                }
                let mainActor = Actor(id: id, image: image, name: name, asCharacter: asCharacter)
                actors.append(mainActor)
            }
            
            let movie = Movie(id: id,
                              title: title,
                              year: year,
                              image: image,
                              releaseDate: releaseDate,
                              runtimeMins: runtimeMins,
                              directors: directors,
                              actorList: actors)
            
        } catch {
            print("Failed to parsed: \(String(describing: jsonString))")
        }
        
        let topPath = documentsURL.appendingPathComponent("top250MoviesIMDB.json")
        let jsongTop = try? String(contentsOf: topPath)
        let dataTop = jsongTop?.data(using: .utf8)
        guard let dataTop = dataTop else { return }
        
        struct MovieTop: Codable {
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
        
        struct Top: Decodable {
            let items: [MovieTop]
        }
        
        do {
            let top = try JSONDecoder().decode(Top.self, from: dataTop)
            
        } catch {
            print("Failed to parse: \(error.localizedDescription)")
        }
        
//        print(NSHomeDirectory())
//        print(Bundle.main.bundlePath)
//        print(documentsURL)
//        print(documentsURL.scheme!)
        print(documentsURL.path)
//
//        let fileName = "text.swift"
//        documentsURL.appendPathComponent(fileName)
//        print(documentsURL.path)
//        if !FileManager.default.fileExists(atPath: documentsURL.path){
//            let hello = "Hello world!"
//            let data = hello.data(using: .utf8)
//            FileManager.default.createFile(atPath: documentsURL.path, contents: data)
//
//        enum FileManagerError: Error {
//            case fileDoesntExist
//        }
//
//        func string(from documentsURL: URL) throws -> String {
//            if !FileManager.default.fileExists(atPath: documentsURL.path) {
//                throw FileManagerError.fileDoesntExist
//            }
//            return try String(contentsOf: documentsURL)
//        }
    }
    
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
    
    private func showAnswerResult(isCorrect: Bool) {
        // отображаем результат ответа (выделяем рамкой верный или неверный ответ)
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen?.cgColor : UIColor.ypRed?.cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showQuestionOrResult()
            self.imageView.layer.borderWidth = 0
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
    }
    
    private func showQuestionOrResult() {
        
        if currentQuestionIndex == questionsAmount - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
            // показать результат квиза
            let title = "Игра окончена"
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, Вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let viewModel = QuizResultsViewModel(title: title, text: text, buttonText: "Cыграть еще раз")
            
            self.show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий вопрос
            // показать следующий вопрос
            questionFactory?.requestNextQuestion()
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        // проверка ответа
        let userAnswer = false
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
        
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        // проверка ответа
        let userAnswer = true
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
}
